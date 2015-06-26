class AddLetTypeIdToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :let_type_id, :integer
    add_column :properties, :let_furn_id, :integer
  end
end
