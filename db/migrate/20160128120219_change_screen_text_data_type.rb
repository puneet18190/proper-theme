class ChangeScreenTextDataType < ActiveRecord::Migration
	def up
    	change_column :settings, :newest_inside_text, :text
	    change_column :settings, :oldest_inside_text, :text
	    change_column :settings, :featured_inside_text, :text
	    change_column :settings, :cycle_inside_text, :text
	    change_column :settings, :random_inside_text, :text
	    change_column :settings, :newest_screen_text, :text
	    change_column :settings, :oldest_screen_text, :text
	    change_column :settings, :featured_screen_text, :text
	    change_column :settings, :cycle_screen_text, :text
	    change_column :settings, :random_screen_text, :text
	end

	def down
	    change_column :settings, :newest_inside_text, :string
	    change_column :settings, :oldest_inside_text, :string
	    change_column :settings, :featured_inside_text, :string
	    change_column :settings, :cycle_inside_text, :string
	    change_column :settings, :random_inside_text, :string
	    change_column :settings, :newest_screen_text, :string
	    change_column :settings, :oldest_screen_text, :string
	    change_column :settings, :featured_screen_text, :string
	    change_column :settings, :cycle_screen_text, :string
	    change_column :settings, :random_screen_text, :string
	end
end
