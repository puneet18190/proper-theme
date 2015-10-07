class AddScreensTextToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :newest_screen, :boolean
    add_column :settings, :newest_screen_text, :string
    add_column :settings, :oldest_screen, :boolean
    add_column :settings, :oldest_screen_text, :string
    add_column :settings, :featured_screen, :boolean
    add_column :settings, :featured_screen_text, :string
    add_column :settings, :cycle_screen, :boolean
    add_column :settings, :cycle_screen_text, :string
    add_column :settings, :random_screen, :boolean
    add_column :settings, :random_screen_text, :string
  end
end
