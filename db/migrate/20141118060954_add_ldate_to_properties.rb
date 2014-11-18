class AddLdateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :l_date, :date
  end
end
