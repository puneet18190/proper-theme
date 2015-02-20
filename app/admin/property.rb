ActiveAdmin.register Property do


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :image1, :image2, :image3, :image4, :image5, :image6, :image7, :image8, :image9, :image10, :description, :date, :visibility, :price, :let, :sold, :featured, :approve, :payment, :user_id, :agent_id
  #
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create Property..." do
      f.input :name
      f.input :address1
      f.input :address2
      f.input :address3
      f.input :postcode
      f.input :bath
      f.input :beds
      f.input :parking
      f.input :category
      f.input :image1
      f.input :image2
      f.input :image3
      f.input :image4
      f.input :image5
      f.input :image6
      f.input :image7
      f.input :image8
      f.input :image9
      f.input :image10
      f.input :description, as: :html_editor
      f.input :date
      f.input :visibility
      f.input :price
      f.input :let
      f.input :sold
      f.input :featured
      f.input :approve
      f.input :payment
      f.input :user_id
      f.input :agent_id
    end
    f.actions
  end
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  before_filter :only => [:show,:edit,:delete,:update,:destroy] do
    @property = Property.friendly.find(params[:id])
  end
end
