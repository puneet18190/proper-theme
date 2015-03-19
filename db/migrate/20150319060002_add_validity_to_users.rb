class AddValidityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :validity, :datetime
  end
end
