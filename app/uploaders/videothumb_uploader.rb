# encoding: utf-8

class VideothumbUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

    storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :display do
    resize_to_limit(600, 400)
  end

  version :display_folder do
    process :crop
    resize_to_fill(248, 150)
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def crop
    if model.crop_x.present?
      resize_to_limit(600, 400)
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop!(x, y, w, h)
      end
    end
  end

end