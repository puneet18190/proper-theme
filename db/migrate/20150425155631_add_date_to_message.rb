class AddDateToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :date, :string
  end
end
