class Photo < ActiveRecord::Base
  
  belongs_to :file_folder

  mount_uploader :image, ImageUploader

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

	def crop_image
		self.image.recreate_versions! if crop_x.present?
	end
end
