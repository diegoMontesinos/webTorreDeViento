class Download < ActiveRecord::Base

	# Carrierwave
	mount_uploader :attachment, DownloadAttachmentUploader
	mount_uploader :thumbnail, VideothumbUploader

	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	
end
