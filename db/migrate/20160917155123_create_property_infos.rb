class CreatePropertyInfos < ActiveRecord::Migration
  def change
    create_table :property_infos do |t|
      t.integer :battery
      t.string :battery_operated
      t.integer :mains
      t.string :mains_operated
      t.integer :carbon
      t.string :carbon_monoxide
      t.string :elec_meter_loc
      t.string :elec_last_supplier
      t.string :gas_meter_loc
      t.string :gas_last_supplier
      t.string :gas_valve
      t.string :water_meter_loc
      t.string :water_stopcock_loc
      t.string :bin_coll_day
      t.string :alarm_loc
      t.string :alarm_code
      t.integer :property_id

      t.timestamps
    end
  end
end
