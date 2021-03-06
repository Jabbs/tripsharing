# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :fog
  
  include CarrierWave::MimeTypes
  process :set_content_type
  
  process :resize_to_limit => [1200, 0]
  
  version :landscape do
    process :resize_to_fill => [1200, 300]
  end
  
  version :landscape_small, :from_version => :landscape do
    process :resize_to_fill => [600, 150]
  end
  
  version :big do
    process :resize_to_limit => [532, 0]
  end
  
  version :medium, :from_version => :big do
    process :resize_to_fill => [330, 330]
  end
  
  version :small, :from_version => :medium do
    process :resize_to_fill => [228, 228]
  end
  
  version :thumb, :from_version => :small do
    process :resize_to_fill => [80, 80]
  end
  
  # rotation issue
  # http://stackoverflow.com/questions/18519160/exif-image-rotation-issue-using-carrierwave-and-rmagick-to-upload-to-s3
  def auto_orient
    manipulate! do |img|
      img = img.auto_orient
    end
  end
  
  process :auto_orient

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.image_attachable_type.downcase.pluralize}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
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
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
