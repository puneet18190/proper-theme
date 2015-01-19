class CreateScreens < ActiveRecord::Migration
  def change
    create_table :screens do |t|
      t.string :name
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
