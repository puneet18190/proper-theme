class ChangePaymentForUsers < ActiveRecord::Migration
  def change
    change_column :users, :payment, :boolean, :default => false
  end
end
