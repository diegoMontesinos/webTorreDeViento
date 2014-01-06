class Photo < ActiveRecord::Base
  belongs_to :file_folder

  mount_uploader :image, ImageUploader
end
