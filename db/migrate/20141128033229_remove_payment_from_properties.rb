class RemovePaymentFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :payment, :boolean
  end
end
