class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :admin_image
      t.string :admin_text

      t.timestamps
    end
  end
end
