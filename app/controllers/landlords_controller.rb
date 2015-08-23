class LandlordsController < ApplicationController
	before_action :set_landlord, only: [:show, :edit, :update, :destroy]
	def index
		@landlords = User.where(status: "landlord")
	end

	def new
		@landlord = User.new(status: "landlord", password: "12345678", password_confirmation: "12345678")
	end

	def create

	end

	def edit

	end

	def update
		@landlord.update(landlord_params)
		redirect_to landlords_path
	end

	def destroy
		@landlord.destroy
		redirect_to landlords_path
	end

	private
	    def set_landlord
	      @landlord = User.where(status: "landlord", id: params[:id]).first
	    end

	    def landlord_params
	      params.require(:user).permit(:first_name,:last_name, :address1, :address2, :address3,:phone,:postcode,:mobile,:dob)
	    end
end
