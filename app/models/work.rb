class Work < ActiveRecord::Base
	has_translations :titles_text, :credits, :synopsis, :program, :notes

	has_many :file_folders, as: :holdable
	accepts_nested_attributes_for :file_folders, :allow_destroy => true

	mount_uploader :video, VideoUploader
	mount_uploader :videothumb, VideothumbUploader

	def set_success(format, opts)
		self.success = true
	end

	def substitute_video_folder
		file_folders = self.file_folders

		if self.video.present?
			return nil
		end

		if self.type_work == "full"
			substitute_folder = file_folders.reject{ |folder| (folder.name_folder == "GALERIA" or folder.name_folder == "DETRAS DE" or folder.name_folder == "OTROS" or folder.name_folder == "DEFAULT") }
			return substitute_folder.first
		else
			return nil
		end
	end
end