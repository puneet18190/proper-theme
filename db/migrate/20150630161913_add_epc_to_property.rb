class AddEpcToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :epc, :string
  end
end
