class AddLandlordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :landlord, :boolean
  end
end
