class AddApproveToUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :approve, :boolean, :default => false
  end
end
