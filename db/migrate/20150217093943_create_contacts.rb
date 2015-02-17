class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_id
      t.string :contact_number
      t.string :comments

      t.timestamps
    end
  end
end
