class Photo < ActiveRecord::Base
  
  belongs_to :file_folder

  mount_uploader :image, ImageUploader

  before_destroy :fix_destroy

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

	def crop_image
		self.image.recreate_versions! if crop_x.present?
	end

	def fix_destroy
		file_folder = self.file_folder

		if file_folder.display == self.id
			photos = file_folder.photos

			random_index = Random.rand(photos.length)
			while photos[random_index].id == self.id do
				random_index = Random.rand(photos.length)
			end

			file_folder.display = photos[random_index].id
			file_folder.save
		end

		self.remove_image!
	end
end
