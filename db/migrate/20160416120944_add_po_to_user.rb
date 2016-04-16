class AddPoToUser < ActiveRecord::Migration
  def change
    add_column :users, :po, :boolean, default: false
  end
end
