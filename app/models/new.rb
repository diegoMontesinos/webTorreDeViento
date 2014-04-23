class New < ActiveRecord::Base

	# Carrierwave
	mount_uploader :image_new, ImageNewUploader
	mount_uploader :thumbnail, NewThumbnailUploader

	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	after_update :crop_thumbnail

	def crop_thumbnail
		self.thumbnail.recreate_versions! if crop_x.present?
	end
	
end
