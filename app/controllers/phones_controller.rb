class PhonesController < ApplicationController
  
  def help
    @data = Phone.new(callerid: params[:call_id], call_action: params[:call_action], dataname: params[:mac])
    @data.save
    render :nothing => true
  end
end
