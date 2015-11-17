class MessagesController < ApplicationController
  layout 'message_layout'
  before_action :authenticate_user!, except: "contact_landlord"

  def new
    @recipient = User.where(id: params['recipients'])
  end

  def create
    recipients = User.where(id: params['recipients'])
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = "Message has been sent!"
    redirect_to conversation_path(conversation)
  end

  def contact_landlord
    recipients = User.where(id: params['user_id'])
    user = User.where(status: "admin").first
    params[:message] = "Name: #{params[:name]} <br/> Email: #{params[:email]} <br/> Message: #{params[:message]}"
    conversation = user.send_message(recipients, params[:message], "New Message").conversation
    flash[:success] = "Message has been sent!"
    redirect_to root_url
  end
end
