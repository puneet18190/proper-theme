class AddPostcodeToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :postcode, :integer
  end
end
