class AddLocalToPhone < ActiveRecord::Migration
  def change
    add_column :phones, :local, :string
    add_column :phones, :remote, :string
  end
end
