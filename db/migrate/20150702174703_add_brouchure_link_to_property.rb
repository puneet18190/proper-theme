class AddBrouchureLinkToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :brochure_link, :string
  end
end
