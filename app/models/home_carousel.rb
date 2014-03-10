class HomeCarousel < ActiveRecord::Base

	has_many :carousel_elements, dependent: :destroy

end
