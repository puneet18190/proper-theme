class AddParkingStatusToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :parking_status, :string, :default => "none"
  end
end
