class AppraisalsController < ApplicationController
	before_action :set_appraisal, only: [:show, :edit, :update, :destroy]

	def show
		
	end

	def edit
		
	end

	def update
		@appraisal.update_attributes(appraisal_params)
		redirect_to :back, notice: "Updated Successfully"
	end

	def destroy
		@appraisal.destroy
		redirect_to :back, notice: "Deleted Successfully"
	end

	private
    def set_appraisal
      @appraisal = Appraisal.where(id: params[:id]).first
    end

    def appraisal_params
      params.require(:appraisal).permit(:firstname,:lastname, :email, :contact, :status, :comments)
    end
end