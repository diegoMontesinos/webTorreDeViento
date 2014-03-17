class HomeController < ApplicationController

  before_filter :authenticate_user!, :only => [ :carousel_store_order ]

  # GET
  def index
  	carousels = HomeCarousel.all
  	@carousel = carousels[Random.rand(carousels.length)]
  end

  def show_carousel
    @carousel = HomeCarousel.find(params[:id])

    render template: "home/index"
  end

  # POST
  def carousel_store_order
  	@carousel = HomeCarousel.find(params[:id])

  	ordered_ids = params[:order].split('_')
  	ordered_ids.each.with_index do |id_elem, index|
  		curr_elem = CarouselElement.find(id_elem.to_i)

  		if index == 0
  			curr_elem.next = ordered_ids[(index + 1) % ordered_ids.length].to_i
  			curr_elem.previous = ordered_ids.last.to_i
  		
  		elsif index == (ordered_ids.length - 1)
  			curr_elem.next = ordered_ids.first.to_i
  			curr_elem.previous = ordered_ids[(index - 1) % ordered_ids.length].to_i
  		
  		else
  			curr_elem.next = ordered_ids[(index + 1) % ordered_ids.length].to_i
  			curr_elem.previous = ordered_ids[(index - 1) % ordered_ids.length].to_i
  		end

  		curr_elem.save
  	end

    @carousel.head = ordered_ids.first.to_i

    if @carousel.save
    	respond_to do |format|
    		format.json {
    			render json: params[:order].to_json
    		}
      end
    end
    
  end

end
