class CreateProvisions < ActiveRecord::Migration
  def change
    create_table :provisions do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
