class UsersController < ApplicationController
	def profile
		@user = current_user
		if current_user.status == "landlord"
			render "landlord_profile"
		elsif current_user.status == "tenant"
			render "tenant_profile"
		end
	end

	def update
		current_user.update(user_params)
		# redirect_to root_url
		if current_user.status == "tenant"
			if current_user.sign_in_count == 1
				redirect_to "/tenant_search"
			else
				redirect_to root_url, notice: "Profile updated Sucessfully."
			end
		else current_user.status == "landlord"
			redirect_to "/properties/new"
		end
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
      	:tenancy_type,:max_price
      )
    end

end
