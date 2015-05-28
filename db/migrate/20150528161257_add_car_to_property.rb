class AddCarToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :car, :integer
  end
end
