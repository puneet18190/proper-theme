class ReportPdf < Prawn::Document
  def initialize(properties)
    super()
    @properties = properties
    header
    text_content
  end

  def header
    image open(@properties.image1.url), width: 540, height: 320
    move_down(6)
    image open(@properties.image2.url), width: 175, height: 100 if (@properties.image2).present?
    move_up(100)
    image open(@properties.image3.url), width: 175, height: 100, :position => :center if (@properties.image3).present?
    move_up(100)
    image open(@properties.image4.url), width: 175, height: 100, :position => :right if (@properties.image4).present?
  end

  def text_content
    if (@properties.image2 || @properties.image3 || @properties.image4).present?
      y_position = cursor - 50
    else
      y_position = cursor - 250
    end
    bounding_box([0, y_position], :width => 270, :height => 300) do
      text "Name: #{@properties.name}", size: 15
      text "Description: #{@properties.description}", size: 15
      text "Address1: #{@properties.address1}", size: 15
      text "Address2: #{@properties.address2}", size: 15
      text "Address3: #{@properties.address3}", size: 15
      text "Price: #{(@properties.price).to_s}", size: 15
      text "Beds: #{(@properties.beds).to_s}", size: 15
      text "Bath: #{(@properties.bath).to_s}", size: 15
      text "Parking: #{(@properties.parking).to_s}", size: 15
      text "Category: #{@properties.category}", size: 15
    end
  end
end


