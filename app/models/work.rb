class Work < ActiveRecord::Base
	has_translations :titles_text, :credits, :synopsis, :program, :notes

	has_many :file_folders, as: :holdable, dependent: :destroy
	accepts_nested_attributes_for :file_folders, :allow_destroy => true

	mount_uploader :video, VideoUploader
	mount_uploader :videothumb, ImageUploader

	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	after_update :crop_videothumb

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

	def crop_videothumb
		self.videothumb.recreate_versions! if crop_x.present?
	end

	def self.works_inorder

		if Work.count == 0
			return nil
		else
			works_inorder = Array.new
			
			work = Work.first
			first_id = work.id

			works_inorder.push(work)
			last_id = work.next

			while last_id != first_id do
				work = Work.find(last_id)
				works_inorder.push(work)
				last_id = work.next				
			end

			return works_inorder
		end
	end
	
end