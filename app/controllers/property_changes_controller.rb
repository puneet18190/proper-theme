class PropertyChangesController < ApplicationController
	before_action :set_property, only: [:show, :edit, :update, :destroy]
	def update
		if current_user.status == "landlord"
	      @property.update(property_changes_params)
	      @property.property.update_attributes(approval_status: "none")
	    end
	    redirect_to "/properties"
	end

	private
    def set_property
      @property = PropertyChange.find(params[:id])
    end

    def property_changes_params
      params.require(:property_change).permit(:name, :address1, :address2, :address3, :postcode, :bath, :beds, :parking, :category, :description, :price,:user_id,:gas_ch,:parking_status,:car,:short_description,:tag_line,:dg,:garden,:property_type,:pets,:ensuite,:town,:status,:postcode1,:qualifier,:summary,:furnished,:feature1,:feature2,:let_type_id,:let_furn_id, :image1,:image2,:image3, :image4,:image5,:image6, :image7, :image8, :image9, :image10, :epc)
    end
end