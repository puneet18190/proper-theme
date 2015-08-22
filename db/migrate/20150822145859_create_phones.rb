class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :callerid

      t.timestamps
    end
  end
end
