class SessionsController < Devise::SessionsController
  # skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'mobile' }
  protect_from_forgery :except => ["create"]
end