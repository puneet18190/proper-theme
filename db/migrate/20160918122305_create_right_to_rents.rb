class CreateRightToRents < ActiveRecord::Migration
  def change
    create_table :right_to_rents do |t|
      t.date :date_check
      t.date :expiry_doc
      t.boolean :doc_recheck
      t.date :recheck_due
      t.integer :property_id

      t.timestamps
    end
  end
end
