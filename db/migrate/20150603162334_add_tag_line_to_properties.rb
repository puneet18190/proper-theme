class AddTagLineToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :tag_line, :text
  end
end
