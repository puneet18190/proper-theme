ActiveAdmin.register Setting do
  permit_params :admin_image, :admin_text
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create Setting..." do
      f.input :admin_image, :as => :file
      f.input :admin_text
    end
    f.actions
  end
end
