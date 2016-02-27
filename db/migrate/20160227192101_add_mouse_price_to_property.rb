class AddMousePriceToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :mouse_price, :boolean, default: false
    add_column :properties, :dss_move, :boolean, default: false
    add_column :properties, :home, :boolean, default: false
    add_column :properties, :wonder_property, :boolean, default: false
  end
end
