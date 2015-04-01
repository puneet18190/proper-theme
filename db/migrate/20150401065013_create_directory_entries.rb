class CreateDirectoryEntries < ActiveRecord::Migration
  def change
    create_table :directory_entries do |t|
      t.string :Name
      t.string :Telephone

      t.timestamps
    end
  end
end
