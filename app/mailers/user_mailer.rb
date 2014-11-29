class UserMailer < ActionMailer::Base
  default :from => 'any_from_address@example.com'
  def deliver_payment_method(user)
    @user = user
    mail( :to => @user.email, :subject => 'Thanks for signing up for our amazing app' )
  end

  def property_approval(property,status)
  	@user = property.user
  	@status = status
    mail( :to => @user.email, :subject => 'Status of Property Approval' )
  end	

end

