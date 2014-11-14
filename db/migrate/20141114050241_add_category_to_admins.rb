class AddCategoryToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :category, :string
  end
end
