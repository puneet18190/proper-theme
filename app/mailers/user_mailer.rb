class UserMailer < ActionMailer::Base
  default :from => 'any_from_address@example.com'
  def deliver_payment_method(property)
    @property = property
    mail( :to => @property.user.email, :subject => 'Payment Confirmation' )
  end

  def property_approval(property,status)
  	@user = property.user
  	@status = status
    mail( :to => @user.email, :subject => 'Status of Property Approval' )
  end

  def payment_remainder(property)
  	@property = property
    mail( :to => @property.user.email, :subject => 'Payment Remainder' )
  end	

  def tenant_result_property(user, properties,request)
    @request = request
    @user = user
    @properties = properties
    # binding.pry
    mail( :to => @user.email, :subject => 'Searching results')
  end

  def property_search_match(user, property,request)
    @request = request
    @user = user
    @property = property
    binding.pry
    mail( :to => @user.email, :subject => 'Searching results')
  end
end

