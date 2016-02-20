class LandlordsController < ApplicationController
	before_action :set_landlord, only: [:show, :edit, :update, :destroy]
	def index
		@landlords = User.where(status: "landlord")
	end

	def new
		@landlord = User.new
	end

	def create
		params[:user][:status] = "landlord"
		params[:user][:password] = "12345678"
		params[:user][:password_confirmation] = "12345678"
		params[:user][:email] = "#{Time.now.to_i}@dummy.com" if params[:user][:email].empty?
		@user = User.new(landlord_params)
		@user.skip_confirmation!
		@user.save!
		redirect_to landlords_path
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
	      params.require(:user).permit(:first_name,:last_name, :address1, :address2, :address3,:phone,:postcode,:mobile,:dob,:status,:password,:password_confirmation,:email, :notes, :plan)
	    end
end
