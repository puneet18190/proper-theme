class UserMailer < ActionMailer::Base
  default :from => 'any_from_address@example.com'
  def deliver_payment_method(user)
    @user = user
    mail( :to => @user.email, :subject => 'Thanks for signing up for our amazing app' )
  end

end

