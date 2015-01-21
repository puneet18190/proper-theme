ActiveAdmin.register Advertisement do
  permit_params :name, :email, :description, :phone, :image, :expiry_date
end
