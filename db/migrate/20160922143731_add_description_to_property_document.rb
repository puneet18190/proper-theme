class AddDescriptionToPropertyDocument < ActiveRecord::Migration
  def change
    add_column :property_documents, :description, :text
  end
end
