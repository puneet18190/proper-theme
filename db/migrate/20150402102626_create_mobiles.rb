class CreateMobiles < ActiveRecord::Migration
  def change
    create_table :mobiles do |t|
      t.string :name
      t.string :telephone

      t.timestamps
    end
  end
end
