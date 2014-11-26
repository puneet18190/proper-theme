class RemoveTenantFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :tenant, :string
  end
end
