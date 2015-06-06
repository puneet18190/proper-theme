# encoding: utf-8

class Image1Uploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
   include CarrierWave::RMagick
   include ::CarrierWave::Backgrounder::Delay
   # include CarrierWave::MiniMagick


  # Choose what kind of storage to use for this uploader:
 # storage :file
  storage :fog
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # process :resize_to_fill => [850, 315]
  process :convert => 'png'
  # process :watermark

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   #ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.jpg"].compact.join('_'))
  #   "/assets" + [:thumb,"default.jpg"].compact.join('_')
  #   # "/assets/fallback/" + [version_name, "default.jpg"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
    # do something
  # end

     def default_url
       'default_images/no.jpg'
     end

  # Create different versions of your uploaded files:
  version :thumb do
    # process :manualcrop
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

 version :seal do
   process :resize_to_fit =>  [500, 500]
   process :watermark
 end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

 def watermark
   manipulate! do |img|
     logo = Magick::Image.read("#{Rails.root}/app/assets/images/seal_watermark.png").first
     img = img.composite(logo, Magick::NorthWestGravity, 15, 0, Magick::OverCompositeOp)
   end

   # // for addition of text watermark #

   # if model.name.present?
   #   manipulate! do |img|
   #     text = Magick::Draw.new
   #     text.gravity = Magick::CenterGravity
   #     text.fill = 'white'
   #     text.pointsize = 40
   #     text.stroke = 'none'
   #     text.annotate(img, 0, 0, 0, 0, "#{model.name}")
   #     img
   #   end
   # end
 end



   # def manualcrop
   #   return unless model.cropping?
   #   manipulate! do |img|
   #     img = img.crop(model.crop_x.to_i,model.crop_y.to_i,model.crop_h.to_i,model.crop_w.to_i)
   #   end
   # end
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
