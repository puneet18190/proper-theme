class ConfirmationsController < Devise::ConfirmationsController
  def after_confirmation_path_for(resource_name, resource)
    # if resource[:status] == "landlord"
    #   @con = RubyZoho::Crm::Contact.new(
    #       :last_name => resource[:first_name],
    #       :email => resource[:email],
    #       :phone => resource[:phone],
    #       :mailing_street => resource[:address]
    #   )
    # @con.save
    # end
    new_user_session_path("user[email]" => params["user"]["email"])
  end
end