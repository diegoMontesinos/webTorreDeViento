class Download < ActiveRecord::Base

	# Carrierwave
	mount_uploader :attachment, DownloadAttachmentUploader
	mount_uploader :thumbnail, DownloadThumbnailUploader

	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	after_update :crop_thumbnail

	def crop_thumbnail
		self.thumbnail.recreate_versions! if crop_x.present?
	end
	
end
