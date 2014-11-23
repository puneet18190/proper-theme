class ScreensController < ApplicationController
	layout proc { false if request.xhr? }
	def page1
		render '/screens/screen2/page1', :layout => "screen_layout"
	end

	def page2
		render '/screens/screen2/page2', :layout => "screen_layout"
	end

	def screen1
		render '/screens/screen1/screen1', :layout => "screen_layout"
	end

	def screen2
		render '/screens/screen2/screen2', :layout => "screen_layout"
	end	
end