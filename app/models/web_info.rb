class WebInfo < ActiveRecord::Base

	has_translations :body

	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	
	mount_uploader :image, ImageUploader

  	before_destroy :fix_destroy

  	def fix_destroy
  		self.remove_image!
  	end
end
