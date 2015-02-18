ActiveAdmin.register Agent do
  permit_params :name, :address, :phone, :image, :email_id, :fb_id, :twitter_id
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create Agent..." do
      f.input :name
      f.input :address
      f.input :phone
      f.input :image
      f.input :email_id
      f.input :fb_id
      f.input :twitter_id
    end
    f.actions
  end
end
