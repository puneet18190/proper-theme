class ChangePropertyDescriptionDateTypeToSetting < ActiveRecord::Migration
  def change
  	change_column :settings, :property_description, :text
  end
end
