class SmsController < ApplicationController
	protect_from_forgery :only => ["send_sms"]

	def send_sms
		@sms = Sms.new(originator: params[:originator], destination: params[:destination], message: params[:message])
		if @sms.save
			render :json => {status: true}
		else
			render :json => {status: false}
		end
	end
end