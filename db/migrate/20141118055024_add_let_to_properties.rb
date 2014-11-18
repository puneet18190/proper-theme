class AddLetToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :let, :boolean
  end
end
