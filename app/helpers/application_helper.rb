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
      data = "TO LET"
    elsif category == "Rent" && status_id == "Let Agreed"
      data = "LET AGREED"
    elsif category == "Sale" && status_id == "Available"
      data = "FOR SALE"
    elsif category == "Sale" && status_id == "SSTC"
      data = "SOLD STC"
    elsif category == "Sale" && status_id == "SSTCM"
      data = "SOLD STC"
    elsif category == "Sale" && status_id == "Reserved"
      data = "RESERVED"
    elsif category == "Sale" && status_id == "Under Offer"
      data = "UNDER OFFER"
    else
      data =""
    end
    return data
  end 
end
