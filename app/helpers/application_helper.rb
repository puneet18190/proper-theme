module ApplicationHelper
  def notice
    flash[:notice]
  end

  def alert
    flash[:alert]
  end

  def gravatar_for(user, size = 30, title = user.name)
    image_tag gravatar_image_url(user.email, size: size), title: title, class: 'img-rounded'
  end

  def page_header(text)
    content_for(:page_header) { text.to_s }
  end

  def responsive_image(image)
    begin
      if request.ip == "82.68.0.86"
        image.url
      else
        if is_mobile_device?
          image.url(:small)
        elsif ::MobileFu::Tablet.is_a_tablet_device? request.user_agent
          image.url(:medium)
        else
          image.url(:large)
        end      
      end
    rescue
      image.url
    end    
  end

  def property_status(category,status_id)
    if category == "Rent" && status_id == "Available"
      data = "To Let"
    elsif category == "Rent" && status_id == "Let Agreed"
      data = "Let Agreed"
    elsif category == "Sale" && status_id == "Available"
      data = "For Sale"
    elsif category == "Sale" && status_id == "SSTC"
      data = "Sold STC"
    elsif category == "Sale" && status_id == "SSTCM"
      data = "Sold STC"
    elsif category == "Sale" && status_id == "Reserved"
      data = "Reserved"
    elsif category == "Sale" && status_id == "Under Offer"
      data = "Under Offer"
    else
      data =""
    end
    return data
  end 

  def agent_name(property)
    property.agent.nil? ? property.user.first_name.capitalize : property.agent.name
  end

  def agent_phone(property)
    property.agent.nil? ? property.user.phone : property.agent.phone
  end

  def agent_email(property)
    property.agent.nil? ? "" : "#{property.agent.name.downcase}@sealproperties.co.uk"
  end

  def agent_image(property)
    property.agent.nil? ? "noimage.gif" : property.agent.image.url(:large).gsub("https","http")
  end
end
