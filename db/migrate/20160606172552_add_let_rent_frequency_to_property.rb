class AddLetRentFrequencyToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :let_rent_frequency, :integer, default: 1
  end
end
