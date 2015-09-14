class AddTownToPropertyChange < ActiveRecord::Migration
  def change
    add_column :property_changes, :town, :string
    add_column :property_changes, :image1, :string
    add_column :property_changes, :image2, :string
    add_column :property_changes, :image3, :string
    add_column :property_changes, :image4, :string
    add_column :property_changes, :image5, :string
    add_column :property_changes, :image6, :string
    add_column :property_changes, :image7, :string
    add_column :property_changes, :image8, :string
    add_column :property_changes, :image9, :string
    add_column :property_changes, :image10, :string
    add_column :property_changes, :epc, :string
  end
end
