class CreateKeyBooks < ActiveRecord::Migration
  def change
    create_table :key_books do |t|
      t.integer :property_id
      t.integer :key_id
      t.string :name
      t.string :status
      t.datetime :book_time
      t.string :person
      t.text :notes

      t.timestamps
    end
  end
end
