class AddScreenInsideToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :newest_inside_text, :string
    add_column :settings, :newest_inside, :boolean
    add_column :settings, :oldest_inside_text, :string
    add_column :settings, :oldest_inside, :boolean
    add_column :settings, :featured_inside_text, :string
    add_column :settings, :featured_inside, :boolean
    add_column :settings, :cycle_inside_text, :string
    add_column :settings, :cycle_inside, :boolean
    add_column :settings, :random_inside_text, :string
    add_column :settings, :random_inside, :boolean
  end
end
