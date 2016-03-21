class CreateSms < ActiveRecord::Migration
  def change
    create_table :sms do |t|
      t.string :originator
      t.string :destination
      t.text :message

      t.timestamps
    end
  end
end
