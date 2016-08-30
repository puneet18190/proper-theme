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

	def prospective
		user=[]
		ids = []
		Property.where.not(approval_status: "approved").includes(:user).each{|obj| ids << obj.user.id}
		User.where(status: "landlord").includes(:properties).each{|obj| ids << obj.id if obj.properties.blank? }
		@users = User.find(ids.uniq)
		@other_users = Appraisal.where(status: "Letting").all
	end

	def active_lead
		user=[]
		Property.where("approval_status = ? AND category = ?  AND status = ? ","approved","Rent","Available").includes(:user).each{|obj| user << obj.user.id}
		@users = User.find(user.uniq)
	end

	def active_landlord_pro
		user=[]
		Property.where(approval_status: "approved").where(status: "Let Agreed").includes(:user).each{|obj| user << obj.user.id if obj.user.plan=="pro"}
		@users = User.find(user.uniq)
	end

	def active_landlord_pro_plus
		user=[]
		Property.where(approval_status: "approved").where(status: "Let Agreed").includes(:user).each{|obj| user << obj.user.id if obj.user.plan=="pro_plus"}
		@users = User.find(user.uniq)
	end

	private
	    def set_landlord
	      @landlord = User.where(status: "landlord", id: params[:id]).first
	    end

	    def landlord_params
	      params.require(:user).permit(:first_name,:last_name, :address1, :address2, :address3,:phone,:postcode,:mobile,:dob,:status,:password,:password_confirmation,:email, :notes, :plan)
	    end
end
