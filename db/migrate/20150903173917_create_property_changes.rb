class CreatePropertyChanges < ActiveRecord::Migration
  def change
    create_table :property_changes do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :postcode
      t.string :postcode1
      t.integer :property_type
      t.integer :beds
      t.integer :bath
      t.string :parking_status, default: "none"
      t.integer :car
      t.string :ensuite, default: "No"
      t.string :let_type_id, default: "Not Specified"
      t.string :let_furn_id, default: "Not Specified"
      t.string :gas_ch, default: "No"
      t.string :garden, default: "No"
      t.string :dg
      t.string :pets, default: "No"
      t.string :feature1
      t.string :feature2
      t.string :category
      t.string :status
      t.decimal :price
      t.text :tag_line
      t.text :summary
      t.text :short_description
      t.text :description
      t.references :property, index: true

      t.timestamps
    end
  end
end
