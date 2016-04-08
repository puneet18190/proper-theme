class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.integer :key_number
      t.string :key_status, default: "unassign"
      t.integer :property_id

      t.timestamps
    end

    (1..1000).each_with_index do |n, i|
      Key.create(key_number: n)
    end
  end
end
