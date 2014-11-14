class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :name
      t.decimal :price
      t.integer :bath
      t.integer :beds
      t.integer :pools

      t.timestamps
    end
  end
end
