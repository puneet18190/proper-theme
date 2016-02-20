class AddMarketingNotesToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :marketing_notes, :text
  end
end
