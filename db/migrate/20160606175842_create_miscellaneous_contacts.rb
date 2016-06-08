class CreateMiscellaneousContacts < ActiveRecord::Migration
  def change
    create_table :miscellaneous_contacts do |t|
      t.string :name
      t.string :company
      t.string :category
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
