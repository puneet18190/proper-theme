class AddKeyAssignDateToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :key_assign_date, :datetime
    add_column :properties, :key_unassign_date, :datetime
  end
end
