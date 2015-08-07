class ApplicationController < ActionController::Base
  # layout :layout_by_resource
  before_filter :configure_devise_params, if: :devise_controller?
  has_mobile_fu
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :first_name, :address, :phone, :status, :last_name)
    end
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do | exception |
    redirect_to root_url, alert: exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:warning] = 'Resource not found.'
    redirect_back_or root_path
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  # protected

  # def layout_by_resource
  #   if is_mobile_device?
  #     puts "============mobile===================="
  #     "mobile"
  #   else
  #     puts "============application===================="
  #     "application"
  #   end
  # end

end

