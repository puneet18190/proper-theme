class PhonesController < ApplicationController
  
  def help
  	# if params[:mac] == "0015654c66c2"
  	# 	mac= "Emma's Shop"
  	# elsif params[:mac] == "0015654c6db2"
  	# 	mac = "Steve's Shop"
  	# else
  	# 	mac=""
  	# end
  		
    @data = Phone.new(callerid: params[:call_id], call_action: params[:call_action], dataname: params[:mac], 
      local: params[:local], remote: params[:remote], 
      display_local: params[:display_local], display_remote: params[:display_remote]
    )
    @data.save
    render :nothing => true
  end

  def get_phone_data
    @data = Phone.all
    render :json => {data: @data}.to_json
  end
end
