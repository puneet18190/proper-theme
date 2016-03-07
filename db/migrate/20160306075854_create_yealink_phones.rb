class CreateYealinkPhones < ActiveRecord::Migration
  def change
    create_table :yealink_phones do |t|
      t.string :name
      t.string :caller_id
      t.string :department
      t.string :status
      t.integer :call_duration
      t.string :callid
      t.string :mac

      t.timestamps
    end
  end
end
