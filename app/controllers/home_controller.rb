class HomeController < ApplicationController

  before_filter :authenticate_user!, :only => [ :carousel_store_order ]

  # GET
  def index
  	carousels = HomeCarousel.all
  	@carousel = carousels[Random.rand(carousels.length)]
  end

  # GET
  def show_carousel
    @carousel = HomeCarousel.find(params[:id])

    render template: "home/index"
  end

  # GET
  def comming_soon
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

  # GET
  def we_are
    @we_are = WebInfo.find_by_type_info("we_are")
    if @we_are.nil?
     @we_are = WebInfo.new
     @we_are.type_info = "we_are"
     @we_are.save
    end
  end

  # GET
  def we_do
    @we_do = WebInfo.find_by_type_info("we_do")
    if @we_do.nil?
      @we_do = WebInfo.new
      @we_do.type_info = "we_do"
      @we_do.save
    end
  end

  # GET
  def list_projects
    @list_projects = WebInfo.find_by_type_info("list_projects")
    if @list_projects.nil?
      @list_projects = WebInfo.new
      @list_projects.type_info = "list_projects"
      @list_projects.save
    end
  end

  # GET
  def links
    @links = WebInfo.find_by_type_info("links")
    if @links.nil?
      @links = WebInfo.new
      @links.type_info = "links"
      @links.save
    end
  end

end
