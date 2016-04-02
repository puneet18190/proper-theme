class PhonesController < ApplicationController
  
  def help
    if (params[:call_action] == "incoming_call")
      number = params[:display_remote].delete('^0-9')
      user =  number.blank? ? "" : User.where("mobile = ? OR phone =?", number, number).first
      name = user.blank? "" : "#{user.first_name} #{user.last_name}"
      Pusher['private'].trigger('new_message', {number: number, name: name})
    end

    @data = Phone.new(callerid: params[:call_id], call_action: params[:call_action], dataname: params[:mac], 
      local: params[:local], remote: params[:remote], 
      display_local: params[:display_local], display_remote: params[:display_remote]
    )
    @data.save

    if (params[:call_action] == "incoming_call" || params[:call_action] == "outgoing_call")
      YealinkPhone.create(callid: params[:call_id],name: params[:display_local], department: params[:display_remote].delete('0-9'),callerid: params[:display_remote].delete('^0-9'), status: "missed", call_duration: 0, mac: params[:mac], callaction: params[:call_action] )
    end

    if params[:call_action] == "call_established"
      call = YealinkPhone.where(callid: params[:call_id], mac: params[:mac]).last
      call.update_attributes(status: "")
    end

    if params[:call_action] == "call_terminated"
      call = YealinkPhone.where(callid: params[:call_id], mac: params[:mac]).last
      duration = DateTime.now.utc.to_f - call.created_at.utc.to_f
      call.update_attributes(status: "answered", call_duration: duration)
    end

    if params[:call_action] == "missed_call"
      call = YealinkPhone.where(callid: params[:call_id], mac: params[:mac])
      if call.blank?
        YealinkPhone.create(callid: params[:call_id],name: params[:display_local], department: params[:display_remote].delete('0-9'),callerid: params[:display_remote].delete('^0-9'), status: "missed", call_duration: 0, mac: params[:mac], callaction: params[:call_action] )
      end
    end

    render :nothing => true
  end

  def get_phone_data
    @data = YealinkPhone.all.where(callaction: "incoming_call")
    render :json => {data: @data}.to_json
  end

  def get_call_handler_api
    @data = YealinkPhone.all.where(callaction: "incoming_call", status: "")
    render :json => {data: @data}.to_json
  end

  def make_call
  	if !params[:extension].blank? || !params[:destination].blank?
	  	Phone.call(params[:extension].to_i, params[:destination].to_i) 
    end
  	render :json => {status: "ok"}
  end

  def get_call_handler
    # if Rails.env=="production"
    #   @data = YealinkPhone.all.where(callaction: "incoming_call", status: "").last
    # else
    #   @data = HTTParty.get("http://www.sealproperties.co.uk/get_call_handler_api")["data"].first
    # end
    # @user = @data.blank? ? nil : User.where("mobile = ? OR phone =?", @data["callerid"],@data["callerid"]).first
    @user = User.where("mobile = ? OR phone =?", params[:number],params[:number]).first
    @number = params[:number]
    render :layout => false
  end

  def get_call_log
    if Rails.env=="production"
      @data = YealinkPhone.all.where(callaction: "incoming_call").last(20)
    else
      @data = HTTParty.get("http://www.sealproperties.co.uk/get_phone_data")["data"]
    end
    render :layout => false
  end

  def send_sms_to_user
    @setting = Setting.all[0]
    if !@setting.sms_destination_no.blank?
      res = HTTParty.post("https://call-api.gradwell.com/0.9.3/sms",:body=>{ 
        :auth=>'4KPDJWZRFOXXS50KXPOA4VTM4S', 
        :originator=>441915805900, 
        :destination=>params[:number].gsub(/^0/, "+44"), 
        :message=>params[:message]})
      render :json => {data: res}
    end
  end

  def record_search
    @user = User.where("first_name ilike ? OR last_name ilike ?", "%#{params[:term]}%", "%#{params[:term]}%").order('first_name')
  end

  def property_search
    @properties = []
    params[:term].split(" ").each do |obj|
      @properties << Property.where("name ilike ? OR address1 ilike ? OR address2 ilike ? OR address3 ilike ? ", 
        "%#{obj}%", "%#{obj}%", "%#{obj}%", "%#{obj}%")
    end
    @properties = @properties.flatten.uniq
  end

  def get_property_data
    @property = Property.find(params[:id])
    render :json => {data: @property.key, status: @property.key.blank? ? "false" : "true"}
  end
end
