# encoding: utf-8

class Image5Uploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
   include CarrierWave::RMagick
   include ::CarrierWave::Backgrounder::Delay
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
   storage :fog
   # process :watermark
   # process :seal_watermark

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
   version :thumb do
     # process :manualcrop
     process :resize_to_fill => [200, 200]
     process :seal_watermark1
   end

   version :large do
     process :resize_to_fit => [500, 500]
     process :seal_watermark
   end

   version :medium do
     process :resize_to_fit => [300, 300]
     process :seal_watermark1
   end

   version :small do
     process :resize_to_fit =>  [120, 120]
     process :seal_watermark1
   end

  # def watermark(opacity = 0.7, size = 's')
  #   manipulate! do |img|
  #     logo = Magick::Image.read("#{Rails.root}/app/assets/images/sp_logo1.png").first
  #     logo.alpha(Magick::ActivateAlphaChannel) 

  #     white_canvas = Magick::Image.new(logo.columns, logo.rows) { self.background_color = "none" }
  #     white_canvas.alpha(Magick::ActivateAlphaChannel)
  #     white_canvas.opacity = Magick::QuantumRange - (Magick::QuantumRange * opacity)

  #     # Important: DstIn composite operation (white canvas + watermark)
  #     logo_opacity = logo.composite(white_canvas, Magick::SouthEastGravity, 0, 0, Magick::DstInCompositeOp)
  #     logo_opacity.alpha(Magick::ActivateAlphaChannel)

  #     # Important: Over composite operation (original image + white canvas watermarked)
  #     img = img.composite(logo_opacity, Magick::SouthEastGravity, 0, 0, Magick::OverCompositeOp)
  #   end
  # end

  def seal_watermark
    manipulate! do |img|
      logo = Magick::Image.read("#{Rails.root}/app/assets/images/sp_logo1.png").first
      img = img.composite(logo, Magick::SouthEastGravity, 0, 0, Magick::OverCompositeOp)
    end
  end

  def seal_watermark1
    manipulate! do |img|
      logo = Magick::Image.read("#{Rails.root}/app/assets/images/sp_logo2.png").first
      img = img.composite(logo, Magick::SouthEastGravity, 0, 0, Magick::OverCompositeOp)
    end
  end
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end