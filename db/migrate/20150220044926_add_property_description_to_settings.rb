class AddPropertyDescriptionToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :property_description, :string
  end
end
