class CreateBlms < ActiveRecord::Migration
  def change
    create_table :blms do |t|
      t.string :name
      t.datetime :upload_time

      t.timestamps
    end

    Blm.create(name: "onthemarket")
    Blm.create(name: "zoopla")
  end
end
