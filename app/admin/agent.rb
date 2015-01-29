ActiveAdmin.register Agent do
  permit_params :name, :address, :phone, :image
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create Agent..." do
      f.input :name
      f.input :address
      f.input :phone
      f.input :image
    end
    f.actions
  end
end
