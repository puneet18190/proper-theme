class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :name
      t.string :description
      t.string :email
      t.string :phone
      t.string :image
      t.date :expiry_date

      t.timestamps
    end
  end
end
