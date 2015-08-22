class PhonesController < ApplicationController
  
  def help
    @data = Phone.new(callerid: params[:call_id])
    @data.save
    render :nothing => true
  end
end
