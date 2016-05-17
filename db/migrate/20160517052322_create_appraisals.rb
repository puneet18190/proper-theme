class CreateAppraisals < ActiveRecord::Migration
  def change
    create_table :appraisals do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :contact
      t.string :status
      t.text :comments

      t.timestamps
    end
  end
end
