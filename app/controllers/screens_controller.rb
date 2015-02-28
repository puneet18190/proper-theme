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
		render '/screens/newest/newest_properties_detail'
	end

	def impress
		render :layout => false
	end	

	def update_screen_status
		Screen.find_by_name("screen_"+params[:screen_id].to_s).update_attributes(:status => params[:status])
		render :json => {:status => "ok"}.to_json
  	end

	def community
  #   	@advertisements = []
  #   	@advertisements = Advertisement.all
  #   	@advertisements_l = @advertisements[0..1]
  #   	@advertisements_m = @advertisements[2..3]
  #   	@advertisements_r = @advertisements[4..5]
  #   	@advertisements_x = @advertisements[6..7]
		# render '/screens/community/community_detail', :layout => "screen_layout"
		@advertisements = []
	    @advertisements_t = []
	    @advertisements_b = []
	    @advertisements = Advertisement.all
	    @total = @advertisements.count
	    @half = @total/2
	    # @count_lt = @total < 3 ? (3-@total) : 0
	    (0..(@half-1)).each do |rec|
	      @advertisements_t << @advertisements[rec]
	    end
	    ((@half)..(@total-1)).each do |dat|
	      @advertisements_b << @advertisements[dat]
	    end
	    render '/properties/advertisements', :layout => "screen_layout"
	end

	def featured_properties
		@properties = Property.where(:featured=>true).last(5)
		render '/screens/oldest/featured', :layout => "screen_layout"
	end	

	def random_properties
		@properties = Property.where(:visibility=>true).sample(5)
		render '/screens/oldest/random', :layout => "screen_layout"
	end	
	def oldest_properties_detail
		@data = Property.find(params[:property_id])
		@postcode = Pat.get(@data.postcode.to_s)
		@datapat = JSON.parse(@postcode.body)
		render '/screens/oldest/oldest_properties_detail'
	end
end