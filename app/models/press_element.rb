class PressElement < ActiveRecord::Base

	belongs_to :press_note

	# Ingles
	has_translations :body

end
