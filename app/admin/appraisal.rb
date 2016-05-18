ActiveAdmin.register Appraisal do
  permit_params :firstname, :lastname, :email, :contact, :status, :comments
end