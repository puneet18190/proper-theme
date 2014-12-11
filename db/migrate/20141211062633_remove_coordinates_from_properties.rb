class RemoveCoordinatesFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :coordinates, :float, {:precision=>10, :scale=>6}
  end
end
