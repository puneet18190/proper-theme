class AddDisplayLocalToPhone < ActiveRecord::Migration
  def change
    add_column :phones, :display_local, :string
    add_column :phones, :display_remote, :string
  end
end
