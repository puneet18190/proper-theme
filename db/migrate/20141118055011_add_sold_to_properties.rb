class AddSoldToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :sold, :boolean
  end
end
