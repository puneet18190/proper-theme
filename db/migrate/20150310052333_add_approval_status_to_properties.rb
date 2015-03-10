class AddApprovalStatusToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :approval_status, :string, :default => "false"
  end
end
