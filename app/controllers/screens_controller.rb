class ScreensController < ApplicationController
	require 'json'
	require 'pat'
	layout proc { false if request.xhr? }
	protect_from_forgery :except => "update_screen_status"
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
		begin
			@data = Property.find(params[:property_id])
			Screen.find_by_name("screen_"+params[:screen_id].to_s).update_attributes(:status => params[:status])
			render '/screens/screen3/screen_properties_detail'
		rescue
			Screen.find_by_name("screen_"+params[:screen_id].to_s).update_attributes(:status => params[:status])
		end	
	end

	def newest
		@properties = Property.where(:visibility=>true).last(5)
		render '/screens/newest/newest', :layout => "screen_layout"
	end

	def newest_properties_detail
		@data = Property.find(params[:property_id])
		@postcode = Pat.get(@data.postcode.to_s)
		@datapat = JSON.parse(@postcode.body)
    @advertisements = []
    @advertisements = Advertisement.all
		render '/screens/newest/newest_properties_detail'
	end

	def impress
		render :layout => false
	end	

	def update_screen_status
		Screen.find_by_name("screen_"+params[:screen_id].to_s).update_attributes(:status => params[:status])
		render :json => {:status => "ok"}.to_json
  end

end