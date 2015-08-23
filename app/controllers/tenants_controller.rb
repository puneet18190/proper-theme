class TenantsController < ApplicationController
	before_action :set_tenant, only: [:show, :edit, :update, :destroy]
	def index
		@tenants = User.where(status: "tenant")
	end

	def new
		@tenant = User.new(status: "tenant", password: "12345678", password_confirmation: "12345678")
	end

	def create

	end

	def edit

	end

	def update
		@tenant.update(tenant_params)
		redirect_to tenants_path
	end

	def destroy
		@tenant.destroy
		redirect_to tenants_path
	end

	private
	    def set_tenant
	      @tenant = User.where(status: "tenant", id: params[:id]).first
	    end

	    def tenant_params
	      params.require(:user).permit(:first_name,:last_name, :address1, :address2, :address3,:phone,:postcode,:mobile,:dob)
	    end
end
