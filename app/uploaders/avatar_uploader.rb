# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  include ::CarrierWave::Backgrounder::Delay

  storage :fog

  process :convert => 'png'
  process :watermark

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'noimage.gif'
  end

  version :thumb do
    process :resize_to_fill => [200, 200]
  end

  version :large do
    process :resize_to_fit => [500, 500]
  end

  version :medium do
    process :resize_to_fit => [300, 300]
  end

  version :small do
    process :resize_to_fit =>  [120, 120]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def watermark(opacity = 0.7, size = 's')
    manipulate! do |img|
      logo = Magick::Image.read("#{Rails.root}/app/assets/images/sp_logo1.png").first
      logo.alpha(Magick::ActivateAlphaChannel) 

      white_canvas = Magick::Image.new(logo.columns, logo.rows) { self.background_color = "none" }
      white_canvas.alpha(Magick::ActivateAlphaChannel)
      white_canvas.opacity = Magick::QuantumRange - (Magick::QuantumRange * opacity)

      logo_opacity = logo.composite(white_canvas, Magick::SouthEastGravity, 0, 0, Magick::DstInCompositeOp)
      logo_opacity.alpha(Magick::ActivateAlphaChannel)

      img = img.composite(logo_opacity, Magick::SouthEastGravity, 0, 0, Magick::OverCompositeOp)
    end
  end
end