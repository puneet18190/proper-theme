class UsersController < ApplicationController
	autocomplete :user, :email, :full => true
	autocomplete :user, :tenant, :full => true
	def profile
		@user = current_user
		if current_user.status == "landlord"
			render "landlord_profile"
		elsif current_user.status == "tenant"
			render "tenant_profile"
		end
	end

	def update
		unless params[:user][:supporting_doc].nil?
	      service = S3::Service.new(:access_key_id => ENV['AWS_ACCESS_KEY'],:secret_access_key => ENV['AWS_SECRET_KEY'])
	      bucket = service.buckets.find("#{ENV['AWS_BUCKET']}")
	      if !current_user.supporting_doc.nil?
	        if !current_user.supporting_doc.empty?
	          a= current_user.supporting_doc.split("https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/").last
	          object = bucket.objects.find(a)
	          object.destroy if object
	        end
	      end
	      object = bucket.objects.build(params[:user][:supporting_doc].original_filename)
	      object.content = params[:user][:supporting_doc].tempfile
	      object.save
	      params[:user][:supporting_doc] = "https://#{ENV['AWS_BUCKET']}.s3.amazonaws.com/"+params[:user][:supporting_doc].original_filename
	    end
    	current_user.update(user_params)
		if current_user.status == "tenant"
			if current_user.sign_in_count == 1
				redirect_to "/tenant_search"
			else
				redirect_to root_url, notice: "Profile updated sucessfully."
			end
		else current_user.status == "landlord"
			redirect_to :back , notice: "Profile updated sucessfully."
		end
	end

    def matches
    	if current_user.status == "landlord"
	    	@data = []
		    @properties = current_user.properties
		    @tenants = User.where(:status => "tenant")
		    @agents = Agent.all.first 2
		    @news = News.all
		    @properties.each do |p|
		      @tenants.each do |t|
		        unless t.search.nil?
		          @string = t.search
		          @words = @string.split('|')
		          @category = @words[0]
		          @type = @words[1]
		          @price_l = @words[2]
		          @price_g = @words[3]
		          @beds = @words[4]
		          @location = @words[5]
		          if @category != "Not Specified" && !@category.nil? && !@category.empty?
		          	status1 = p.category.include?(@category) ? true : false
		          else
		          	status1 = true
		          end
		          if @beds != "Not Specified" && !@beds.nil? && !@beds.empty?
		          	status2 = p.beds.equal?(@beds.to_i) ? true : false
		          else
		          	status2 = true
		          end
		          if @location != "Not Specified" && !@location.nil? && !@location.empty?
		          	status3 = (p.address1.include?(@location) || p.address2.include?(@location) || p.address3.include?(@location) || p.town.include?(@location)) ? true : false
		          else
		          	status3 = true
		          end
		          if (@price_l != "Not Specified" && !@price_l.nil? && !@price_l.empty?) && (@price_g != "Not Specified" && !@price_g.nil? && !@price_g.empty?)
		          	status4 = (@price_g.to_i..@price_l.to_i).cover?(p.price) ? true : false
		          elsif (@price_l != "Not Specified" && !@price_l.nil? && !@price_l.empty?)
		          	status4 = p.price < @price_l.to_i ? true : false
		          elsif (@price_g != "Not Specified" && !@price_g.nil? && !@price_g.empty?)
		          	status4 = p.price > @price_g.to_i ? true : false
		          else
		          	status4 = true
		          end
		          if @type != "Not Specified" && !@type.nil? && !@type.empty? && !PropertyType.where(p_id: p.property_type)[0].nil?
		          	status5 = PropertyType.where(p_id: p.property_type)[0].p_type.equal?(@type) ? true : false
		          else
		          	status5 = true
		          end

		          if status1 == true && status2 == true && status3 == true && status4 == true && status5 == true
		          	@data << t
		          end
		          @data = @data.uniq
		          # if p.category.include?(@category) && (@price_l.to_i..@price_g.to_i).cover?(p.price) && p.beds.equal?(@beds.to_i) && p.bath.equal?(@bath.to_i)
		          #   @data << t
		          # end 
		        end 
		      end
		    end
		elsif current_user.status == "tenant"
			@agents = Agent.all.first 2
			if current_user.search.nil?
				@data = nil
				@status = false
			else
				@string = current_user.search
	        	@words = @string.split('|')
	        	category = @words[0]
	        	type = @words[1]
	        	price_less_than = @words[2]
	        	price_greater_than = @words[3]
	        	beds = @words[4]
	        	location = @words[5]

				# @abc = params[:q]
			    params={}
			    @abc={}
			    category = @abc[:category_cont]= @words[0]
			    type = @abc[:property_type]= @words[1]
			    price_less_than = @abc[:price_lteq]= @words[2]
			    price_greater_than = @abc[:price_gteq]= @words[3]
			    beds = @abc[:beds_eq]= @words[4]
			    location = @abc[:address1_or_address2_or_address3_cont]= @words[5]
			    params[:q] = @abc
			    @all_property = Property.where({visibility: true, approval_status: "approved"})

			    if params[:q][:beds_eq] == "Not Specified"
			      params[:q].delete(:beds_eq)
			    end    

			    if params[:q][:property_type] == "Not Specified"
			      params[:q].delete(:property_type)
			      @search = @all_property.search(params[:q])
			    else
			      a=PropertyType.where(search: params[:q][:property_type])
			      ids = []
			      a.each do |o|
			        ids << o.p_id.to_s
			      end
			      @properties = @all_property.where(property_type: ids)
			      # ids.each do |o|
			      #   data = Property.where(property_type: o)
			      #   @properties << data unless data.empty?
			      # end
			      @properties = @all_property if @properties.blank?
			      @search = @properties.search(params[:q])
			    end

			    @properties = @search.result
			    @data = []
			    @properties.includes(:user).each do |obj|
			    	@data << obj.user
			    end
			    @data = @data.uniq
			    @status = true
			end
		end	
    end

    def show
    	if params[:id] == "autocomplete_user"
    		@user = User.where("first_name ilike ? OR last_name ilike ?", "%#{params[:term]}%", "%#{params[:term]}%").order('first_name')	
    	else
    	if params[:term].blank?
	    	@user = User.find params[:id] 
	    elsif params[:id] == "autocomplete_user_tenant"
    		@user = User.where(status: "tenant").where("first_name ilike ? OR last_name ilike ?", "%#{params[:term]}%", "%#{params[:term]}%").order('first_name')
    	else
    		@user = User.where(status: "landlord").where("first_name ilike ? OR last_name ilike ?", "%#{params[:term]}%", "%#{params[:term]}%").order('first_name')
    	end
    	end
    end

	def get_user_data
		user = User.find(params[:id])
		render :json => {user: user}.to_json
	end

	def contact_notes
		user = User.find(params[:id])
		user.contact_notes.create(notes: params[:contact_note][:notes])
		# render :nothing => true
		redirect_to :back
	end

	def bookanappraisal
		@appraisal = Appraisal.new
	end

	def save_appraisal
		@appraisal = Appraisal.new(appraisal_params)
		@appraisal.save
		UserMailer.book_appraisal(@appraisal).deliver
		redirect_to :back, notice: "Appraisal Booked sucessfully."
	end

    private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
      	:title,:first_name,:last_name, :address1, :address2, :address3,:postcode,:mobile,
      	:phone,:dob,:price,:deposit,:tenancy,:student,:benefit,:pets,:smoker,:property_type,
      	:beds,:bath,:garden,:parking,:gas_ch,:dg,:ensuite,:furnished,:employment,
      	:tenancy_type,:max_price, :avatar, :supporting_doc, :additional_info
      )
    end

    def appraisal_params
    	params.require(:appraisal).permit(:firstname, :lastname, :contact, :email, :comments, :status)
    end
end
