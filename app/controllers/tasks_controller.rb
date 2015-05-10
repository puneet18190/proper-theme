class TasksController < ApplicationController
  layout proc { false if request.xhr? }	
  def index
    if is_mobile_device? == false
      @properties = Property.where({payment: true, visibility: true})

      if !params[:q].nil? && params[:q][:radius]!="Select"
        @properties = @properties.near(params[:q][:postcode_eq],params[:q][:radius].to_f)
      end

      params[:q].delete("postcode_eq") if params[:q] && params[:q][:postcode_eq]
      params[:q].delete("radius") if params[:q] && params[:q][:radius]

      @search = @properties.search(params[:q])
      #@locations = Property.near(params[:q][:address1],params[:q][:radius].to_f) unless params[:q].nil?
      # unless params[:q].nil?
      #   @result = []
      #   @result.push(@search.result)
      #   @result.push(@locations) unless @locations.nil?
      #   @tasks = @result.flatten
      # else
        @tasks = @search.result

      # end
      @agents= Agent.all
      @news= News.all
      @settings = Setting.all.first
    else
      @properties = Property.where({payment: true, visibility: true})
      @search = @properties.search(params[:q])
      @tasks = @search.result
      @agents= Agent.all
      @news= News.all
      render "mobile_page.html.erb", :layout => false
    end  
  end

  def home_simple
    @properties = Property.where({payment: true, visibility: true})
    @search = @properties.search(params[:q])
    @tasks = @search.result
    @agents= Agent.all
    @news= News.all
    render "mobile_page.html.erb", :layout => false
  end

  def properties_detail
    begin
      @data = Property.friendly.find(params[:id])
      @agents = Agent.find_by_id(@data.agent_id)
      @contact_agent = ContactAgent.new
      redirect_to root_url, alert: "No Property Found" unless @data.payment == true
    rescue Exception => e
      redirect_to root_url, alert: "No Property Found"
    end
  end

  def properties_filter
    @prop = Property.all
    @agents = Agent.all
  end

  def properties_map
    @prop = Property.all
    @agents = Agent.all
  end

  def upload_step1
    @property = Property.new
  end

  def search_results
    @properties = Property.where({payment: true, visibility: true})
    @search = @properties.search(params[:q])
    @tasks = @search.result
  end

  def agents
    @agents= Agent.all
  end

  def contact
    @contact = Contact.new
  end

  def con
    @contact = Contact.new(con_params)
    if verify_recaptcha
      @contact.save!
      redirect_to "/contact", notice: "Thank You for posting your query, we will come back to you soon......"
    else
      redirect_to "/contact", alert: "Please re-enter captcha......"
    end
  end

  def contact_agent
    @contact_agent = ContactAgent.new(contact_agent_params)
    @contact_agent.save
    UserMailer.query_message(@contact_agent).deliver
    redirect_to :back, notice: "Thank You for posting your query, we will come back to you soon......"
  end

  private
  def con_params
    params.require(:contact).permit(:first_name, :last_name, :email_id, :contact_number, :comments)
  end

  def contact_agent_params
    params.require(:contact_agent).permit(:name, :email, :message, :agent_id)
  end

end
