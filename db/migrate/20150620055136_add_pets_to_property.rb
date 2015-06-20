class AddPetsToProperty < ActiveRecord::Migration
  def change
  	add_column :properties, :pets, :boolean, :default => "false"
  	add_column :properties, :ensuite, :boolean, :default => "false"
  end
end
