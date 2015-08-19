class UserMailer < ActionMailer::Base
  default :from => 'donotreply@sealproperties.co.uk'
  def deliver_payment_method(property)
    @property = property
    mail( :to => @property.user.email, :subject => 'Payment Confirmation' )
  end

  def property_approval(user, property, status)
  	@user = user
    @property = property
  	@status = status
    mail( :to => @property.user.email, :subject => 'Status of Property Approval' )
  end

  def payment_remainder(property)
  	@property = property
    mail( :to => @property.user.email, :subject => 'Payment Remainder' )
  end	

  def tenant_result_property(user, properties,request)
    @request = request
    @user = user
    @properties = properties
    mail( :to => @user.email, :subject => 'Searching results')
  end

  def property_search_match(user, property,request)
    @request = request
    @user = user
    @property = property
    mail( :to => @user.email, :subject => 'Searching results')
  end

  def query_message(contact_agent)
    @contact_agent = contact_agent
    @agent = Agent.find_by_id(@contact_agent.agent_id)
    mail( :to => @agent.email_id, :subject => 'User Query')
  end

  def auto_respond_mail(email)
    @email = email
    mail( :to => @email, :subject => 'Auto Respond Mail' )
  end

  def copy_to_emma(user, message)
    @message = message
    mail( :to => "emma@sealproperties.co.uk", :subject => "Mail From #{user}" )
  end

  def blm_status(message)
    @message = message
    mail( :to => "puneetgupta18190@gmail.com", :subject => "BLM status")
  end

end

