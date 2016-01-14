class AddTenantIdToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :tenant_id, :integer
  end
end
