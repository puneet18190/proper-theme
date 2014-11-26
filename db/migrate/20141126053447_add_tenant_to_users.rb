class AddTenantToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tenant, :boolean
  end
end
