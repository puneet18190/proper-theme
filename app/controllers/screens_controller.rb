class ScreensController < ApplicationController
	def page1

	end

	def auto
		
	end

	def screen1
		render '/screens/screen1/screen1', :layout => "screen_layout"
	end

	def screen2
		render '/screens/screen2/screen2', :layout => "screen_layout"
	end	
end