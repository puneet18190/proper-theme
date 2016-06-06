class AddZooplaToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :zoopla, :boolean, default: true
    add_column :properties, :nethouse, :boolean, default: true
  end
end
