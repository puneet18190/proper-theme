class AddTenantStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :tenant_status, :string
  end
end
