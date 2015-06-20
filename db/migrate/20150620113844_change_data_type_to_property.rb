class ChangeDataTypeToProperty < ActiveRecord::Migration
  def change
  	change_column :properties, :ensuite,  :string, default: "No"
  	change_column :properties, :gas_ch,  :string, default: "No"
  	change_column :properties, :garden,  :string, default: "No"
  	change_column :properties, :pets,  :string, default: "No"
  end
end
