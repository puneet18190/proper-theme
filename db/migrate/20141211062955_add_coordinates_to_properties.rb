class AddCoordinatesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :coordinates, :string
  end
end
