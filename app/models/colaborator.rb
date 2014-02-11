class Colaborator < ActiveRecord::Base

	has_translations :semblance_text
	mount_uploader :cv, PdfUploader
	mount_uploader :cv_en, PdfUploader
	mount_uploader :semblance, PdfUploader
	mount_uploader :semblance_en, PdfUploader

	mount_uploader :sproket_1, SprocketUploader
	mount_uploader :sproket_2, SprocketUploader
	mount_uploader :portrait, PortraitUploader

	attr_accessor :next, :previous

	def self.colaborators_inorder

		if Colaborator.count == 0
			return Colaborator.all
		else
			return Colaborator.all.order(:name)
		end
	end
end
