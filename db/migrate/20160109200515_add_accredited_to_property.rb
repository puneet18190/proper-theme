class AddAccreditedToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :accredited, :boolean
    add_column :properties, :licensed, :boolean
    add_column :properties, :tenant_criteria, :string
    add_column :properties, :cp12, :string
    add_column :properties, :esc, :string

    add_column :properties, :bond, :string
    add_column :properties, :deal, :text
    add_column :properties, :stage, :string
    add_column :properties, :managed, :boolean
    add_column :properties, :board, :boolean
  end
end
