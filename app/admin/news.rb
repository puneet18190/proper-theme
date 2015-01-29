ActiveAdmin.register News do
  permit_params :title, :description, :image
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create News..." do
      f.input :title
      f.input :description
      f.input :image, :as => :file
    end
    f.actions
  end
end
