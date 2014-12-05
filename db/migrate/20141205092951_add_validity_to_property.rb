class AddValidityToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :validity, :datetime
  end
end
