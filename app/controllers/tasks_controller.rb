class TasksController < ApplicationController
  layout proc { false if request.xhr? }	
  respond_to :html, :xml, :json,:mobile, :tablet
  def index
    if !current_user.nil? && current_user.sign_in_count == 1
      redirect_to "/users/profile"
    else
    # if is_mobile_device? == false
      @properties = Property.where({payment: true, visibility: true, approve: true})

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
      respond_with(@properties,@search,@tasks,@agents,@news,@settings)
    # else
    #   @properties = Property.where({payment: true, visibility: true, approve: true}).take(3)
    #   @agents= Agent.all
    #   render "mobile/index.html.erb"#,:layout => "mobile"
    # end
    end  
  end

  def home_simple
    if  request.format.symbol == :mobile
      redirect_to "/"
    else
      @properties = Property.where({payment: true, visibility: true, approve: true})
      @search = @properties.search(params[:q])
      @tasks = @search.result
      @agents= Agent.all
      @news= News.all
      respond_with(@properties,@search,@tasks,@agents,@news)
    end
    # render "mobile_page.html.erb", :layout => false
  end

  def properties_detail
    # if is_mobile_device?
    #   @data = Property.friendly.find(params[:id])
    #   @agents = Agent.find_by_id(@data.agent_id)
    #   @contact_agent = ContactAgent.new
    #   render "properties_detail.html.erb"
    # else  
      begin
        @data = Property.friendly.find(params[:id])
        @agents = @data.agent
        @contact_agent = ContactAgent.new
        # redirect_to root_url, alert: "No Property Found" unless @data.payment == true
        # respond_to do |format|
        #   format.html
        #   format.mobile
        # end
      rescue Exception => e
        redirect_to root_url, alert: "No Property Found. "
      end
      respond_with(@data,@agents,@contact_agent)
    # end  
  end

  def properties_filter
    if request.xhr?
      @data = Property.order("#{params["condition"]} #{params["sort"]}").includes(:agent)
    else  
      @data = Property.order("price asc").includes(:agent)
    end  
    @agents = Agent.all
    respond_with(@data,@agents)
  end

  def properties_map
    @prop = Property.all
    @agents = Agent.all
    respond_with(@prop,@agents)
  end

  def upload_step1
    @property = Property.new
  end

  def search_results
    @properties = Property.where({payment: true, visibility: true, approve: true})
    if params[:q][:postcode_cont] != ""
      address2 = @properties.search(:address2_cont => params[:q][:postcode_cont])
      unless address2.result.empty?
        params[:q][:address2_cont] = params[:q][:postcode_cont]
      end

      address3 = @properties.search(:address3_cont => params[:q][:postcode_cont])
      unless address3.result.empty?
        params[:q][:address3_cont] = params[:q][:postcode_cont]
      end

      postcode = @properties.search(:postcode_cont => params[:q][:postcode_cont])
      if postcode.result.empty?
        params[:q].delete("postcode_cont")
      end
    end

    @search = @properties.search(params[:q])
    @tasks = @search.result
  end

  def agents
    @agents=  Agent.includes(:properties)
    respond_with(@agents)
  end

  def contact
    @contact = Contact.new
    respond_with(@contact)
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
    redirect_to :back, notice: "We will be in touch shortly. "
  end

  def sitemap
    @static_pages = [root_url, contact_url]
    @property = Property.all
  end  

  def news
    @news = News.all

    @p_title = []
    @p_description = []
    @p_image = []
    agent = Mechanize.new
    page = agent.get('http://www.propertyreporter.co.uk/rss.asp')
    response = Nokogiri::XML::Document.parse(page.body, nil, "UTF-8")
    response.css('title').each do |t|
      @p_title.push(t.text)
    end  
    response.css('description').each do |t|
      @p_image.push(t.text.split("<br />")[0])
      @p_description.push(t.text.split("<br />")[1])
    end
    respond_with(@p_title,@p_image,@p_description )
  end  

  def testimonials
    @testimonials = Testimonial.all
    respond_with(@testimonials)
  end

  def seal_approved

  end

  private
  def con_params
    params.require(:contact).permit(:first_name, :last_name, :email_id, :contact_number, :comments)
  end

  def contact_agent_params
    params.require(:contact_agent).permit(:name, :email, :message, :agent_id, :page_link)
  end

end
