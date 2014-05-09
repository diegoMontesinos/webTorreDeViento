class PressNote < ActiveRecord::Base

	has_many :press_elements, dependent: :destroy

	# Carrierwave
	mount_uploader :background, BackgroundPressUploader

end
