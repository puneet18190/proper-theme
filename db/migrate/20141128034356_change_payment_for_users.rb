class ChangePaymentForUsers < ActiveRecord::Migration
  def change
    change_column :users, :payment, :boolean, :default => 0
  end
end
