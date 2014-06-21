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
	before_destroy :fix_destroy

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
		frequents = Colaborator.frequents_colaborators

		if frequents.length == 0
			return frequents
		else
			# Obtenemos la cabeza de la lista
			frequents = frequents.reject { |colab| colab.previous_frequent != -1 }

			frequents_inorder = Array.new

			frequent = frequents.first
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

	def fix_destroy

		# remove uploads
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

		# fix inorder
		id_prev = self.previous_frequent
		id_next = self.next_frequent

		# Obtenemos los vecinos
		p = -1
		if id_prev != -1
			p = Colaborator.find_by_id(id_prev)
			id_prev = p.id
		end
		
		n = -1
		if id_next != -1
			n = Colaborator.find_by_id(id_next)
			id_next = n.id
		end

		# Los alteramos
		if p != -1
			p.next_frequent = id_next
			p.save
		end

		if n != -1
			n.previous_frequent = id_prev
			n.save
		end
	end
end
