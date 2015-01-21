class AdvertisementsController < ApplicationController
  # before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
  # respond_to :html, :xml, :json
  #
  # def index
  #   @advertisements= Advertisement.all
  #   respond_with(@advertisements)
  # end
  #
  # def new
  #   @advertisement= Advertisement.new
  #   respond_with(@advertisement)
  # end
  #
  # def create
  #   @advertisement= Advertisement.new(advertisement_params)
  #   if @advertisement.save
  #      redirect_to @advertisement
  #   else
  #      render 'new'
  #   end
  # end
  #
  # def show
  #   respond_with(@advertisement)
  # end
  #
  # def edit
  # end
  #
  # def update
  #   if @advertisement.update(advertisement_params)
  #     redirect_to @advertisement
  #   else
  #     render 'edit'
  #   end
  # end
  #
  # def destroy
  #   @advertisement.destroy
  #   respond_with(@advertisement)
  # end
  #
  # private
  #
  # def set_advertisement
  #   @advertisement= Advertisement.find(params[:id])
  # end
  #
  #
  # def advertisement_params
  #   params.require(:advertisement).permit(:name, :description, :email, :phone, :image, :expiry_date)
  # end

end
