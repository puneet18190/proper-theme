class AddPortalVisibilityToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :portal_visibility, :boolean, default: true
  end
end
