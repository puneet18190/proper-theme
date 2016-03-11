class CreateContactNotes < ActiveRecord::Migration
  def change
    create_table :contact_notes do |t|
      t.string :notes
      t.references :user, index: true

      t.timestamps
    end
  end
end
