class ChangePostcodeFormatInProperty < ActiveRecord::Migration
  def change
  	change_column :properties, :postcode, :string
  end
end
