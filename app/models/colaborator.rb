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
	before_destroy :remove_uploads

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

	def self.frequents_inorder

		if Colaborator.frequents_colaborators == 0
			return Colaborator.frequents_colaborators
		else
			frequents_inorder = Array.new
			
			frequent = Colaborator.where("previous_frequent = -1").first
			frequents_inorder.push(frequent)
			
			last_id = frequent.next_frequent

			while last_id != -1 do
				frequent = Colaborator.find(last_id)
				frequents_inorder.push(frequent)
				last_id = frequent.next_frequent
			end

			return frequents_inorder
		end
	end

	def remove_uploads
		grid_element = ColaboratorGridElement.find_by_colaborator_id(self.id)
		if !grid_element.nil?
			grid_element.colaborator = nil
			grid_element.remove_sprocket!
			grid_element.save
		end

		self.remove_cv!
		self.remove_cv_en!
		self.remove_semblance!
		self.remove_semblance_en!

		self.remove_sproket_1!
		self.remove_sproket_2!
		self.remove_portrait!

		self.save
	end
end
