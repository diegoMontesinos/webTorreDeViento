class New < ActiveRecord::Base

	# Carrierwave
	mount_uploader :image_new, ImageNewUploader
	mount_uploader :thumbnail, NewThumbnailUploader

	attr_accessor :crop_x1, :crop_y1, :crop_w1, :crop_h1, :crop_x2, :crop_y2, :crop_w2, :crop_h2
	after_update :crop_thumbnail

	def crop_thumbnail
		self.thumbnail.recreate_versions! if crop_x1.present?
		self.thumbnail.recreate_versions! if crop_x2.present?
	end
	
end
