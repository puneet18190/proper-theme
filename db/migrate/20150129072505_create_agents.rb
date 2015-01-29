class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :image

      t.timestamps
    end
  end
end
