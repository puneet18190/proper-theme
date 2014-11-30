class AddPaymentToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :payment, :boolean, :default => false
  end
end
