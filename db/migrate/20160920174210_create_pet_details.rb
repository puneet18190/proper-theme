class CreatePetDetails < ActiveRecord::Migration
  def change
    create_table :pet_details do |t|
      t.string :pet_name
      t.string :pet_type
      t.string :pet_breed
      t.string :pet_age
      t.integer :property_id

      t.timestamps
    end
  end
end
