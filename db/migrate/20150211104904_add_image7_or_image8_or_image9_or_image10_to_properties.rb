class AddImage7OrImage8OrImage9OrImage10ToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :image7, :string
    add_column :properties, :image8, :string
    add_column :properties, :image9, :string
    add_column :properties, :image10, :string
  end
end
