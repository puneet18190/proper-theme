class AddRadiusToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :radius, :string
  end
end
