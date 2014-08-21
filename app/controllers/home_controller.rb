class HomeController < ApplicationController

  before_filter :authenticate_user!, :only => [ :carousel_store_order ]

  # GET
  def index
    # Carousel aleatorio
  	carousels = HomeCarousel.all
  	@carousel = carousels[Random.rand(carousels.length)]

    # Home news
    home_news = HomeNew.all.order('home_news.created_at DESC')
    count = HomeNew.count
    if count != 4

      # Corrigiendo el numero
      if(count > 4)
        dif = count - 4
        i = 0
        dif.times do
          @home_news[i].destroy
        end
      end

      if(count < 4)
        dif = 4 - count
        dif.times do
          home_new = HomeNew.new
          home_new.save
        end
      end

      home_news = HomeNew.all.order('home_news.created_at DESC')
    end

    # Tomamos las noticias en orden
    @home_new_1 = home_news[0]
    @home_new_2 = home_news[1]
    @home_new_3 = home_news[2]
    @home_new_4 = home_news[3]
  end

  # GET
  def show_carousel
    # Carousel
    @carousel = HomeCarousel.find(params[:id])

    # Home news
    home_news = HomeNew.all.order('home_news.created_at DESC')
    count = HomeNew.count
    if count != 4

      # Corrigiendo el numero
      if(count > 4)
        dif = count - 4
        i = 0
        dif.times do
          @home_news[i].destroy
        end
      end

      if(count < 4)
        dif = 4 - count
        dif.times do
          home_new = HomeNew.new
          home_new.save
        end
      end

      home_news = HomeNew.all.order('home_news.created_at DESC')
    end

    # Tomamos las noticias en orden
    @home_new_1 = home_news[0]
    @home_new_2 = home_news[1]
    @home_new_3 = home_news[2]
    @home_new_4 = home_news[3]

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

  # GET
  def contact
  end

  # POST
  def contact_mail
    UserMailer.contact_us(params[:name], params[:mail], params[:mssg]).deliver

    respond_to do |format|
      format.json {
        render json: "ok".to_json
      }
    end
  end

  # GET
  def video
    render partial: "video"
  end

end
