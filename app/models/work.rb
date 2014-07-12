class Work < ActiveRecord::Base

	has_translations :titles_text, :titles_grid, :credits, :synopsis, :program, :notes

	has_many :file_folders, as: :holdable, dependent: :delete_all
	accepts_nested_attributes_for :file_folders, :allow_destroy => true

	has_one :grid_element

	before_destroy :fix_destroy

	# Carrierwave
	mount_uploader :video, VideoUploader
	mount_uploader :videothumb, VideothumbUploader

	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	after_update :crop_videothumb

	def substitute_video_folder
		file_folders = self.file_folders

		if self.video.present?
			return nil
		end

		if self.type_work == "full"
			
			substitute_folder = file_folders.reject{ |folder|
				(folder.name_folder_in_es == "GALERIA" or folder.name_folder_in_en == "BEHIND" or folder.name_folder_in_es == "OTROS" or folder.name_folder_in_es == "DEFAULT")
			}

			return substitute_folder.first
		else
			return nil
		end
	end

	def fix_destroy
		if self.grid_element.present?
			self.grid_element.work = nil
			self.grid_element.display = nil
			self.grid_element.save
		end

		p = Work.find_by_id(self.previous)
		n = Work.find_by_id(self.next)

		p.next = n.id
		n.previous = p.id

		p.save
		n.save
	end

	def filefolder (name_filefolder)
		folders = self.file_folders
		folders = folders.reject { |folder|
			folder.name_folder_in_es != name_filefolder
		}

		if folders.empty?
			return nil
		else
			return folders.first
		end
	end

	def crop_videothumb
		if crop_x.present?
			self.videothumb.recreate_versions!
		end
	end

	def self.works_inorder

		if Work.count == 0
			return Work.all
		else
			works_inorder = Array.new
			
			work = Work.first
			works_inorder.push(work)
			
			first_id = work.id
			last_id = work.next

			while last_id != first_id do
				work = Work.find(last_id)
				works_inorder.push(work)
				last_id = work.next
			end

			return works_inorder
		end
	end

	def self.dimensions_box(box)
		if (box == "0" or box == "3" or box == "14" or box == "12")
			return { "w" => 248, "h" => 123 }

		elsif (box == "1" or box == "4" or box == "7" or box == "9" or box == "11" or box == "13")
			return { "w" => 123, "h" => 123 }

		elsif (box == "2" or box == "6" or box == "8" or box == "10")
			return { "w" => 248, "h" => 248 }
			
		elsif box == "5"
			return { "w" => 123, "h" => 248 }
		end
	end

	def self.print_inorder
		if Work.count == 0
			puts ""
		else
			work = Work.first
			
			first_id = work.id
			last_id = work.next
			puts (first_id.to_s + " <-> " + last_id.to_s)

			while last_id != first_id do
				work = Work.find(last_id)
				puts (last_id.to_s + " <-> " + work.next.to_s)
				last_id = work.next
			end
		end
	end
	
end