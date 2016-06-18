class SetDefaultToDssMove < ActiveRecord::Migration
  def change
  	change_column :properties, :dss_move, :boolean, :default => true
  	change_column :properties, :mouse_price, :boolean, :default => true
  	change_column :properties, :home, :boolean, :default => true
  	change_column :properties, :wonder_property, :boolean, :default => true
  	change_column :properties, :otm, :boolean, :default => true
  end
end