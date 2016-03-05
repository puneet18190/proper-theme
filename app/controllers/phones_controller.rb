class PhonesController < ApplicationController
  
  def help
  	if params[:mac] == "0015654c66c2"
  		mac= "Emma's Shop"
  	elsif params[:mac] == "0015654c6db2"
  		mac = "Steve's Shop"
  	end
  		
    @data = Phone.new(callerid: params[:call_id], call_action: params[:call_action], dataname: params[:mac], local: params[:local], remote: params[:remote])
    @data.save
    render :nothing => true
  end
end
