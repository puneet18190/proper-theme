class AddFieldsToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :garden, :boolean, :default => "false"
    add_column :properties, :dg, :boolean, :default => "false"
  end
end
