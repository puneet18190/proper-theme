class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :title, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :address1, :string
    add_column :users, :address2, :string
    add_column :users, :address3, :string
    add_column :users, :postcode, :string
    add_column :users, :mobile, :integer
    add_column :users, :employment, :string
    add_column :users, :price, :integer
    add_column :users, :deposit, :string
    add_column :users, :tenancy, :integer
    add_column :users, :student, :string
    add_column :users, :benefit, :string
    add_column :users, :pets, :string
    add_column :users, :smoker, :string
    add_column :users, :property_type, :string
    add_column :users, :beds, :integer
    add_column :users, :bath, :integer
    add_column :users, :max_price, :integer
    add_column :users, :furnished, :string
    add_column :users, :garden, :string
    add_column :users, :ensuite, :string
    add_column :users, :parking, :string
    add_column :users, :gas_ch, :string
    add_column :users, :dg, :string
    add_column :users, :tenancy_type, :string
    add_column :users, :dob, :date
  end
end
