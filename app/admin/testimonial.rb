ActiveAdmin.register Testimonial do
  permit_params :name, :title, :testimonial,:t_date,:user_type
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create News..." do
      f.input :title
      f.input :name
      f.input :testimonial
      f.input :t_date
      f.input :user_type, as: :select, collection: ["Landlord","Tenant","Buyer","Seller"]
    end
    f.actions
  end
end
