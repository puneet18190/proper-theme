class AddShortDescriptionToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :short_description, :text
    add_column :properties, :gas_ch, :boolean, :default => "false"
    add_column :properties, :glazing, :boolean, :default => "false"
  end
end
