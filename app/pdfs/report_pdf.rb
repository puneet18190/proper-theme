require 'htmlentities'
class ReportPdf < Prawn::Document
  include ActionView::Helpers::SanitizeHelper
  def initialize(properties)
    super()
    @properties = properties
    content
  end

  def content
    coder = HTMLEntities.new
    if (@properties.image10).present?
      image open(@properties.image10.url), width: 150, height: 110
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 150, height: 110
    end
    move_up(100)
    text "#{@properties.name}", size: 30, :align => :right if (@properties.name).present?
    text "Address: #{@properties.address1}", size: 13, :align => :right if (@properties.address1).present?
    text "Price: #{(@properties.price).to_s}", size: 13, :align => :right if (@properties.price).present?
    text "Phone: #{User.find(@properties.user_id).phone}", size: 13, :align => :right if (@properties.user_id).present?
    move_down(27)
    if (@properties.image1).present?
      image open(@properties.image1.url), width: 540, height: 370
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 540, height: 370
    end
    move_down(6)
    if (@properties.image2).present?
      image open(@properties.image2.url), width: 267, height: 215, :position => :left
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 267, height: 215, :position => :left
    end
    move_up(215)
    if (@properties.image3).present?
      image open(@properties.image3.url), width: 267, height: 215, :position => :right
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 267, height: 215, :position => :right
    end
    text "#{@properties.address1}", size: 15 if (@properties.address1).present?
    text "#{@properties.address2}", size: 15 if (@properties.address2).present?
    text "#{@properties.address3}", size: 15 if (@properties.address3).present?
    move_up(50)
    image open("https://maps.googleapis.com/maps/api/staticmap?size=300x200&maptype=roadmap&sensor=false&zoom=13&markers=#{((@properties.coordinates).nil? ? "" :(@properties.coordinates).split(",")[0].to_f)}%2C#{((@properties.coordinates).nil? ? "" :(@properties.coordinates).split(",")[1].to_f)}"), :position => :right
    move_down(80)
    text "Description: #{coder.decode strip_tags(@properties.description)}", size: 20, :align => :left if (@properties.description).present?
    move_down(10)
    text "Beds: #{(@properties.beds).to_s}", size: 20, :align => :left if (@properties.beds).present?
    move_down(10)
    text "Bath: #{(@properties.bath).to_s}", size: 20, :align => :left if (@properties.bath).present?
    move_down(10)
    text "Parking: #{(@properties.parking)}", size: 20, :align => :left
    move_down(10)
    text "Category: #{@properties.category}", size: 20, :align => :left if (@properties.category).present?
    move_down(10)
    text "Sold: #{@properties.sold}", size: 20, :align => :left
    move_down(10)
    text "Let: #{@properties.let}", size: 20, :align => :left
    move_down(10)
    text "Featured: #{@properties.featured}", size: 20, :align => :left
    move_down(180)
    if (@properties.image4).present?
      image open(@properties.image4.url), width: 267, height: 215, :position => :left
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 267, height: 215, :position => :left
    end
    move_up(215)
    if (@properties.image5).present?
      image open(@properties.image5.url), width: 267, height: 215, :position => :right
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 267, height: 215, :position => :right
    end
    move_down(6)
    if (@properties.image6).present?
      image open(@properties.image6.url), width: 540, height: 350
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 540, height: 350
    end
    move_down(6)
    if (@properties.image7).present?
      image open(@properties.image7.url), width: 175, height: 135, :position => :left
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 175, height: 135, :position => :left
    end
    move_up(135)
    if (@properties.image8).present?
      image open(@properties.image8.url), width: 175, height: 135, :position => :center
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 175, height: 135, :position => :center
    end
    move_up(135)
    if (@properties.image9).present?
      image open(@properties.image9.url), width: 175, height: 135, :position => :right
    else
      image open("#{Rails.root}/app/assets/images/default_images/no.jpg"), width: 175, height: 135, :position => :right
    end
    text "Contact Info: #{User.find(@properties.user_id).phone}", size: 13, :align => :left if (@properties.user_id).present?
    text "Address: #{@properties.address1} #{@properties.address2} #{@properties.address3}", size: 13, :align => :left if (@properties.address1).present?
    text "Agent Info: #{Agent.find_by_id(@properties.agent_id).name}, #{Agent.find_by_id(@properties.agent_id).address}, #{Agent.find_by_id(@properties.agent_id).phone}", size: 13, :align => :left if (@properties.agent_id).present?
  end
end


