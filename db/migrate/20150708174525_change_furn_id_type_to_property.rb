class ChangeFurnIdTypeToProperty < ActiveRecord::Migration
  def change
  	change_column :properties, :let_type_id,  :string, default: "Not Specified"
  	change_column :properties, :let_furn_id,  :string, default: "Not Specified"
  end
end
