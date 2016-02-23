class CreatePropertyDocuments < ActiveRecord::Migration
  def change
    create_table :property_documents do |t|
      t.string :name
      t.string :url
      t.date :date_completed
      t.date :due_date
      t.references :property, index: true

      t.timestamps
    end
  end
end
