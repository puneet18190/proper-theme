class AddTenantPropertyIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :tenant_property_id, :integer
  end
end
