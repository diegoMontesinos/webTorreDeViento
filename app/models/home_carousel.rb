class HomeCarousel < ActiveRecord::Base

	has_many :carousel_elements, dependent: :destroy

	def elements_inorder
		elems_inorder = Array.new

		elem = CarouselElement.find(self.head)
		elems_inorder.push(elem)
		
		first_id = elem.id
		last_id = elem.next

		while last_id != first_id do
			elem = CarouselElement.find(last_id)
			elems_inorder.push(elem)
			last_id = elem.next
		end

		return elems_inorder
	end

end
