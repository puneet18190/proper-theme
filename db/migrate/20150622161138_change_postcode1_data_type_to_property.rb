class ChangePostcode1DataTypeToProperty < ActiveRecord::Migration
  def change
  	change_column :properties, :postcode1,  :string
  end
end
