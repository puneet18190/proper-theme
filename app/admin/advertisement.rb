ActiveAdmin.register Advertisement do
  permit_params :name, :email, :description, :phone, :image, :expiry_date
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create Advertisement..." do
      f.input :name
      f.input :email
      f.input :description
      f.input :phone
      f.input :image #, :as => :file, :hint => f.template.image_tag(f.object.image.url(:thumb))
      f.input :expiry_date
    end
    f.actions
  end
end
