class AddCountToBlm < ActiveRecord::Migration
  def change
    add_column :blms, :count, :integer, default: 0
  end
end
