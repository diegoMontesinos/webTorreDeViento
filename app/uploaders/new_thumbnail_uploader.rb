# encoding: utf-8

class NewThumbnailUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :normalize do
    resize_to_limit(623, 308)
  end

  version :display1 do
    process :crop1
    resize_to_fill(249, 123)
  end

  version :display2 do
    process :crop2
    resize_to_fill(249, 150)
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def crop1
    if model.crop_x1.present?
      resize_to_limit(623, 308)
      manipulate! do |img|
        x = model.crop_x1.to_i
        y = model.crop_y1.to_i
        w = model.crop_w1.to_i
        h = model.crop_h1.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

  def crop2
    if model.crop_x2.present?
      resize_to_limit(623, 308)
      manipulate! do |img|
        x = model.crop_x2.to_i
        y = model.crop_y2.to_i
        w = model.crop_w2.to_i
        h = model.crop_h2.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

end
