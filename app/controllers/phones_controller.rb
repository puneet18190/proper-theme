class PhonesController < ApplicationController
  
  def help
    if (params[:call_action] == "incoming_call")
      number = params[:display_remote].delete('^0-9')
      user =  number.blank? ? "" : User.where("mobile = ? OR phone =?", number, number).first
      name = user.blank? ? "" : "#{user.first_name} #{user.last_name}"
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
    @user = User.where("mobile ilike ? OR phone ilike ?", "%#{params[:number].gsub(/^0/, "")}%","%#{params[:number].gsub(/^0/, "")}%").first
    @number = params[:number]
    n=params[:number].gsub(/^0/, "")
    a=[]
    a << YealinkPhone.all.where("callaction = ? AND callerid ilike ?",  "incoming_call", "%#{n}%").select(:status, :created_at).last(5)

    a << @user.contact_notes.select(:notes, :created_at)
    a= a.flatten.sort_by &:created_at
    @data = a.first 5

    render :layout => false
  end

  def get_call_log
    #if Rails.env=="production"
      # @data = YealinkPhone.all.where(callaction: "incoming_call").last(20)

      @data = YealinkPhone.where("created_at >= ? AND callaction = ?", Time.zone.now - 5.days, "incoming_call").order("created_at desc").group_by(&:callerid)
    #else
    #  @data = HTTParty.get("http://www.sealproperties.co.uk/get_phone_data")["data"]
    #end
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
    render :layout => false
    # render :json => {data: @property.key, status: @property.key.blank? ? "false" : "true"}
  end

  def search_user_by_name_property
    @user = []
    @user << User.where("first_name ilike ? OR last_name ilike ?", "%#{params[:term]}%", "%#{params[:term]}%").order('first_name')
    Property.where("name ilike ? OR address1 ilike ? OR address2 ilike ? OR address3 ilike ?" , 
      "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%").each do |p|
        @user << p.user
        TenantProperty.all.where(property_id: p.id).each do |t|
          @user << User.where(id: t.tenant_id) unless t.tenant_id.blank?
        end
    end
    @user = @user.flatten.uniq
  end

  def search_user_and_property
    @user = []
    @user = User.where("first_name ilike ? OR last_name ilike ?", "%#{params[:term]}%", "%#{params[:term]}%").order('first_name')
    @property = Property.where("name ilike ? OR address1 ilike ? OR address2 ilike ? OR address3 ilike ?" , 
      "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%")
  end

  def sticky_user_search_data
    @user = User.find(params[:id])
    render layout: false
  end

  def sticky_property_search_data
    @property = Property.find(params[:id])
    @landlord = @property.user
    tenant_id = TenantProperty.where(property_id: @property.id).first.try("tenant_id")
    @tenant = tenant_id.nil? ? nil : User.find(tenant_id)
    render layout: false
  end

  def key_book
    if params[:book] == "key_book_in"
      KeyBook.find(params[:id]).update_attributes(book_time: DateTime.now, status: "Available", person: "", notes: "")
    else
      KeyBook.find(params[:id]).update_attributes(book_time: DateTime.now, status: "Unavailable", person: params[:person], notes: params[:notes])
    end
    render :nothing => true
  end
end
