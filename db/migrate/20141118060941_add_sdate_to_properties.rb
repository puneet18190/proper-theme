class AddSdateToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :s_date, :date
  end
end
