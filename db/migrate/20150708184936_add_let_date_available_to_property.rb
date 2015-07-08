class AddLetDateAvailableToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :let_date_available, :datetime
  end
end
