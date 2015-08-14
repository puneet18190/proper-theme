class AddOtmToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :otm, :boolean, default: false
  end
end
