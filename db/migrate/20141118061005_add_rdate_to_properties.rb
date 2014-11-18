class AddRdateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :r_date, :date
  end
end
