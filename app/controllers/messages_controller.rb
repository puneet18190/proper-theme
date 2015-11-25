class MessagesController < ApplicationController
  layout 'message_layout'
  before_action :authenticate_user!, except: "contact_landlord"

  def new
    @recipient = User.where(id: params['recipients'])
    @user = User.where(id: params['user']).first
  end

  def create
    recipients = User.where(id: params['recipients'])
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = "Message has been sent!"
    redirect_to conversation_path(conversation)
  end

  def contact_landlord
    if user_signed_in?
      recipients = User.where(id: params['user_id'])
      # user = User.where(status: "admin").first
      # params[:message] = "Name: #{params[:name]} <br/> Email: #{params[:email]} <br/> Message: #{params[:message]} <br/> <a href='mailto:#{params[:email]}' target='_top'>Click here to reply.</a>"
      conversation = current_user.send_message(recipients, params[:message], "An External Mail Client").conversation
      redirect_to :back, notice: "Your message has been sent to the Landlord."
    else
      session[:name] = params[:name]
      session[:email] = params[:email]
      redirect_to "/users/sign_up"
    end
  end
end
