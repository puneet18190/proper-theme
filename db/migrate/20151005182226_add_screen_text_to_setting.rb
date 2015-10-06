class AddScreenTextToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :screen_text, :string
  end
end
