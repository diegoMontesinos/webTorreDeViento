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
		colaborators = Colaborator.all.order(:name)
		colaborators = colaborators.reject { |colab| colab.frequent }

		colaborators.push("COLABORADORES FRECUENTES")
		colaborators.sort { |x,y|
			if (x.is_a? Colaborator)
				if (y.is_a? Colaborator)
					x.name <=> y.name
				else
					x.name <=> y
				end
			else
				if (y.is_a? Colaborator)
					x <=> y.name
				else
					x <=> y
				end
			end
		}

		return colaborators
	end

	def self.frequents_colaborators
		colaborators = Colaborator.all.order(:name)
		colaborators = colaborators.reject { |colab| colab.frequent == false }

		return colaborators
	end
end
