ActiveAdmin.register Setting do
  permit_params :admin_image, :admin_text, :property_description
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create Setting..." do
      f.input :admin_image, :as => :file
      f.input :admin_text
      f.input :property_description, as: :html_editor
    end
    f.actions
  end
end
