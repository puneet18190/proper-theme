class AddLetAgreedDateToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :let_agreed_date, :datetime
    add_column :properties, :sold_date, :datetime
  end
end
