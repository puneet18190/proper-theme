class CreateTenantProperties < ActiveRecord::Migration
  def change
    create_table :tenant_properties do |t|
      t.integer :property_id
      t.integer :tenant_id

      t.timestamps
    end
  end
end
