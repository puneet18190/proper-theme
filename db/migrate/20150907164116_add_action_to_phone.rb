class AddActionToPhone < ActiveRecord::Migration
  def change
    add_column :phones, :call_action, :string
    add_column :phones, :dataname, :string
  end
end
