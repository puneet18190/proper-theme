class CreateTenantHistroys < ActiveRecord::Migration
  def change
    create_table :tenant_histroys do |t|
      t.string :name
      t.date :tenancy_start_date
      t.date :tenancy_end_date
      t.integer :property_id

      t.timestamps
    end
  end
end
