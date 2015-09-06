class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :additional_info, :text
    add_column :users, :supporting_doc, :string
  end
end
