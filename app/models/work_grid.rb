class WorkGrid < ActiveRecord::Base

	has_many :grid_elements, dependent: :destroy

end
