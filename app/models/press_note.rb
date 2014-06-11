class PressNote < ActiveRecord::Base

	has_many :press_elements, dependent: :destroy

	# Carrierwave
	mount_uploader :background, BackgroundPressUploader

	before_destroy :fix_destroy

	# INORDER
	def self.press_notes_inorder

		if PressNote.count == 0
			return PressNote.all
		else
			press_notes_inorder = Array.new
			
			press_note = PressNote.where("previous = -1").first
			press_notes_inorder.push(press_note)
			
			last_id = press_note.next

			while last_id != -1 do
				press_note = PressNote.find(last_id)
				press_notes_inorder.push(press_note)
				last_id = press_note.next
			end

			return press_notes_inorder
		end
	end

	def fix_destroy
		id_prev = self.previous
		id_next = self.next

		# Obtenemos los vecinos
		p = -1
		if id_prev != -1
			p = PressNote.find_by_id(id_prev)
			id_prev = p.id
		end
		
		n = -1
		if id_next != -1
			n = PressNote.find_by_id(id_next)
			id_next = n.id
		end

		# Los alteramos
		if p != -1
			p.next = id_next
			p.save
		end

		if n != -1
			n.previous = id_prev
			n.save
		end
	end

end
