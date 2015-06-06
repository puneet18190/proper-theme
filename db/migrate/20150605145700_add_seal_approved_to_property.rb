class AddSealApprovedToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :seal_approved, :boolean, :default => "false"
  end
end
