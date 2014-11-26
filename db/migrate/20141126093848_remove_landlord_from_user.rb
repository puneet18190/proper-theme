class RemoveLandlordFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :landlord, :string
  end
end
