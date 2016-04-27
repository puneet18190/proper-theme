class SmsController < ApplicationController
	protect_from_forgery :only => ["send_sms"]

	def send_sms
		@sms = Sms.new(originator: params[:originator], destination: params[:destination], message: params[:message])
		@user = User.where("mobile = ? OR phone =?", params[:originator],params[:originator]).first
		name = @user.blank? ? "" : "#{@user.first_name} #{@user.last_name}"
		user_type = @user.blank? ? "" : @user.status[0].capitalize

		Pusher['private'].trigger('receive_sms', {
			caller_id: params[:originator], 
			name: name, 
			message: params[:message], 
			received_date: DateTime.now.strftime("%d/%m/%Y"),
			received_time: DateTime.now.in_time_zone('London').strftime("%T"),
			user_type: user_type
		})
		if @sms.save
			render :json => {status: true}
		else
			render :json => {status: false}
		end
	end
end