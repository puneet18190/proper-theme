class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :address1
      t.string :address2
      t.string :address3
      t.decimal :amount
      t.integer :bath
      t.integer :beds
      t.boolean :parking
      t.string :image1
      t.string :image2
      t.string :image3
      t.string :image4
      t.string :image5
      t.string :image6
      t.text :description
      t.date :date
      t.boolean :visibility

      t.timestamps
    end
  end
end
