class MiscellaneousContactsController < ApplicationController
	before_action :set_misc_contact, only: [:show, :edit, :update, :destroy]

	def index
		@contact = MiscellaneousContact.all
	end

	def create
		@contact = MiscellaneousContact.new(misc_contact_params)
		@contact.save
		redirect_to miscellaneous_contacts_path
	end

	def new
		@contact = MiscellaneousContact.new
	end

	def edit
		
	end

	def show

	end

	def update
		@contact.update(misc_contact_params)
		redirect_to miscellaneous_contacts_path
	end

	def destroy
		@contact.destroy
		redirect_to miscellaneous_contacts_path
	end

	private
    def set_misc_contact
      @contact = MiscellaneousContact.where(id: params[:id]).first
    end

    def misc_contact_params
      params.require(:miscellaneous_contact).permit(:name,:company, :category, :phone,:email)
    end
end
