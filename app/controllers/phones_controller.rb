class PhonesController < ApplicationController
  
  def help
  	# if params[:mac] == "0015654c66c2"
  	# 	mac= "Emma's Shop"
  	# elsif params[:mac] == "0015654c6db2"
  	# 	mac = "Steve's Shop"
  	# else
  	# 	mac=""
  	# end
  		
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
    render :nothing => true
  end

  def get_phone_data
    @data = YealinkPhone.all.where(callaction: "incoming_call")
    render :json => {data: @data}.to_json
  end

  def get_call_handler
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
    # @data = YealinkPhone.where(status: "").last
    @data = HTTParty.get("http://www.sealproperties.co.uk/get_call_handler")["data"].first
    @user = @data.blank? ? nil : User.where("mobile = ? OR phone =?", @data["callerid"],@data["callerid"]).first
    render :layout => false
    # render :json => {data: @data}.to_json
  end
end
