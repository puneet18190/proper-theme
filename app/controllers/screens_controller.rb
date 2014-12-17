class ScreensController < ApplicationController
	require 'json'
	require 'pat'
	layout proc { false if request.xhr? }
	def page1
		render '/screens/screen2/page1'
	end

	def page2
		render '/screens/screen2/page2'
	end

	def screen1
		render '/screens/screen1/screen1', :layout => "screen_layout"
	end

	def screen2
		render '/screens/screen2/screen2', :layout => "screen_layout"
	end

	def screen3
		@properties = Property.where(:visibility=>true).last(5)
		render '/screens/screen3/screen3', :layout => "screen_layout"
	end	

	def screen_properties_detail
		@data = Property.find(params[:property_id])
		render '/screens/screen3/screen_properties_detail'
	end

	def newest
		@properties = Property.where(:visibility=>true).last(5)
		render '/screens/newest/newest', :layout => "screen_layout"
	end

	def newest_properties_detail
		@data = Property.find(params[:property_id])
		@postcode = Pat.get(@data.postcode.to_s)
		@datapat = JSON.parse(@postcode.body)
		render '/screens/newest/newest_properties_detail'
	end

	def impress
		render :layout => false
	end	
end