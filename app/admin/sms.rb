ActiveAdmin.register Sms do
  permit_params :originator, :destination, :message
end
