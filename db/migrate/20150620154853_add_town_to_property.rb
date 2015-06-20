class AddTownToProperty < ActiveRecord::Migration
  def change
  	add_column :properties, :town, :string
  	add_column :properties, :status, :string
  	add_column :properties, :postcode1, :integer
  	add_column :properties, :qualifier, :string
  	add_column :properties, :summary, :text
  	add_column :properties, :furnished, :string
  	add_column :properties, :feature1, :string
  	add_column :properties, :feature2, :string
  end
end
