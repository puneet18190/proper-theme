class AddLastNameToMiscContact < ActiveRecord::Migration
  def change
  	add_column :miscellaneous_contacts, :last_name, :string
  	rename_column :miscellaneous_contacts, :name, :first_name
  	add_column :miscellaneous_contacts, :position, :string
  	add_column :miscellaneous_contacts, :mobile, :string
  	add_column :miscellaneous_contacts, :web, :string
  	add_column :miscellaneous_contacts, :notes, :text
  	add_column :miscellaneous_contacts, :avatar, :string
  end
end
