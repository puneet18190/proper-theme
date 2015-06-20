class ChangeDgFromProperty < ActiveRecord::Migration
  def change
  	change_column :properties, :dg,  :string
  end
end
