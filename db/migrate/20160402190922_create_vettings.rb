class CreateVettings < ActiveRecord::Migration
  def change
    create_table :vettings do |t|
      t.string :vetting_type
      t.date :submission_date
      t.date :outcome_date
      t.string :outcome
      t.boolean :guarantor
      t.string :vetting_doc
      t.references :property

      t.timestamps
    end
  end
end
