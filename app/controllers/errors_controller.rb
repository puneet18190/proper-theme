class ErrorsController < ApplicationController
  def not_found
  	if is_mobile_device?
    	render :layout => "mobile"
    else
    	render(:status => 404)
    end
  end

  def internal_server_error
    if is_mobile_device?
    	render :layout => "mobile"
    else
    	render(:status => 500)
    end
  end
end