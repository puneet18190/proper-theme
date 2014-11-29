class AddApproveToProperties < ActiveRecord::Migration
  def change
  	add_column :properties, :approve, :boolean, :default => false
  end
end
