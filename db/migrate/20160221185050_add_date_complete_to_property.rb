class AddDateCompleteToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :epc_date_complete, :date
    add_column :properties, :epc_due_date, :date
    add_column :properties, :cp12_date_complete, :date
    add_column :properties, :cp12_due_date, :date
    add_column :properties, :esc_date_complete, :date
    add_column :properties, :esc_due_date, :date
  end
end
