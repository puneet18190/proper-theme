class CreatePropertyTypes < ActiveRecord::Migration
  def change
    create_table :property_types do |t|
      t.string :p_type
      t.string :search
      t.integer :p_id

      t.timestamps
    end
  end
end
