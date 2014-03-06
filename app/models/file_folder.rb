class FileFolder < ActiveRecord::Base

	has_translations :name_folder

	belongs_to :holdable, polymorphic: true

	has_many :photos, dependent: :delete_all

	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	after_update :crop_display

	def crop_display
		if crop_x.present?
			photo_display = Photo.find(self.display)
			photo_display.crop_x = self.crop_x.to_i
			photo_display.crop_y = self.crop_y.to_i
			photo_display.crop_w = self.crop_w.to_i
			photo_display.crop_h = self.crop_h.to_i

			photo_display.crop_image
		end
	end
end