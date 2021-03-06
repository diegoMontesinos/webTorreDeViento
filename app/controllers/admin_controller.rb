class AdminController < ApplicationController

	before_filter :authenticate_user!
	skip_before_filter :verify_authenticity_token, :only => [:save_colab_gridelem]

	# GET
	def show
		redirect_to comming_soon_path
	end

	### ADMIN OBRAS

	# GET
	def new_work
		@work = Work.new

		render partial: "admin_new_work"
	end

	# GET
	def edit_work
		@work = Work.find(params[:id])

		render partial: "admin_edit_work", locals: { work: @work }
	end

	# GET
	def works
		@works = Work.works_inorder

		render partial: "admin_works"
	end

	### ADMIN RODILLO DE OBRAS

	# GET
	def works_grids
		if WorkGrid.count == 0 
			first_grid = WorkGrid.new 
			15.times { |count|
				grid_element = first_grid.grid_elements.build
				grid_element.box = count.to_s
			}

			first_grid.save
		end

 		@work_grids = WorkGrid.all
		render partial: "admin_works_grids", locals: { work_grids: @work_grids }
	end

	# GET
	def new_work_grid
		@work_grid = WorkGrid.new 
		15.times { |count|
			grid_element = @work_grid.grid_elements.build
			grid_element.box = count.to_s
		}

		if @work_grid.save
			respond_to do |format|
				format.json {
					render json: @work_grid.to_json
				}
			end
		end
	end

	# GET
	def work_grid_edit
		@work_grid = WorkGrid.find(params[:id])
		@grid_elements = @work_grid.grid_elements

		render partial: "admin_edit_work_grid", locals: { work_grid: @work_grid, grid_elements: @grid_elements, count: params[:count] }
	end

	# DELETE
	def work_grid_delete
		@work_grid = WorkGrid.find(params[:id])
		id_work_grid = @work_grid.id

		@work_grid.destroy

		respond_to do |format|
			format.json {
				render json: id_work_grid.to_json
			}
		end
	end

	# GET
	def work_grid_elem_edit
		@grid_element = GridElement.find(params[:id])
		@works = Work.all
		@dimensions = Work.dimensions_box(params[:div].gsub 'grid-element-', '')

		render partial: "admin_edit_grid_element", locals: { grid_element: @grid_element, works: @works, div: params[:div], dimensions: @dimensions }
	end

	# POST
	def work_grid_elem_clean
		@grid_element = GridElement.find(params[:id])
		@grid_element.work = nil
		@grid_element.display = nil
		@grid_element.save

		respond_to do |format|
			format.json {
				render json: "".to_json
			}
		end
	end

	# PATCH
	def save_grid_elem
		@grid_element = GridElement.find(params[:id])
		@grid_element.work = Work.find(params[:grid_element][:work_id])

		@grid_element.display = params[:grid_element][:display]
		@grid_element.x = params[:grid_element][:x].to_f
		@grid_element.y = params[:grid_element][:y].to_f
		@grid_element.w = params[:grid_element][:w].to_f
		@grid_element.h = params[:grid_element][:h].to_f

		if @grid_element.save

			info = { :image => Photo.find(@grid_element.display).image.url(:display),
						 :x => @grid_element.x,
						 :y => @grid_element.y,
						 :w => @grid_element.w,
						 :h => @grid_element.h }

			respond_to do |format|
				format.json {
					render json: info.to_json
				}
			end
		end
	end

	### ADMIN COLABORADORES

	# GET
	def new_colaborator
		@colaborator = Colaborator.new

		render partial: "admin_new_colaborator"
	end

	# GET
	def edit_colaborator
		@colaborator = Colaborator.find(params[:id])

		render partial: "admin_edit_colaborator"
	end

	# GET
	def colaborators
		@colaborators = Colaborator.all

		render partial: "admin_colaborators"
	end

	# GET
	def order_frequents
		@frequents_colaborators = Colaborator.frequents_inorder

		render partial: "admin_order_frequents"
	end

	# GET
	def colaborators_home
		if ColaboratorGridElement.count == 0
			28.times { |count|
				colab_grid_element = ColaboratorGridElement.new
				colab_grid_element.box = count.to_s

				colab_grid_element.save
			}
		end

		@colaborator_grid_elements = ColaboratorGridElement.all

		render partial: "admin_colaborators_home"
	end

	# GET
	def colab_gridelement
		@grid_element = ColaboratorGridElement.find(params[:id])

		@colaborators = Colaborator.all
		@colaborators = @colaborators.reject { |colab| colab.frequent }

		render partial: "admin_colab_gridelement", locals: { grid_element: @grid_element, colaborators: @colaborators, div: params[:div] }
	end

	# PATH
	def save_colab_gridelem
		@grid_element = ColaboratorGridElement.find(params[:id])
		img_str = ""

		if params[:colaborator_grid_element][:colaborator_id] != ""
			@grid_element.colaborator = Colaborator.find(params[:colaborator_grid_element][:colaborator_id])

			if @grid_element.save
				img_str = @grid_element.colaborator.sproket_1.url(:display)
			end
		else
			if params[:colaborator_grid_element][:accessFrequent] == "false"
				permitted_params = params.require(:colaborator_grid_element).permit(:sprocket, :accessFrequent)
			else
				permitted_params = params.require(:colaborator_grid_element).permit(:sprocket, :sprocket2, :accessFrequent)
			end
			
			if @grid_element.update(permitted_params)
				if @grid_element.colaborator.present?
					@grid_element.colaborator = nil

					if @grid_element.save
						img_str = @grid_element.sprocket.url(:display)						
					end
				else
					img_str = @grid_element.sprocket.url(:display)
				end
			end
		end

		respond_to do |format|
			format.json {
				render json: img_str.to_json
			}
		end

	end

	# POST
	def clean_colab_gridelem
		@grid_element = ColaboratorGridElement.find(params[:id])
		@grid_element.colaborator = nil
		@grid_element.remove_sprocket!
		@grid_element.save

		respond_to do |format|
			format.json {
				render json: "".to_json
			}
		end
	end

	# HOME
	# Noticias
	def home_news
		count = HomeNew.count
		@home_news = HomeNew.all.order('home_news.created_at DESC')
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

			@home_news = HomeNew.all.order('home_news.created_at DESC')
		end
		
		render partial: "admin_home_news"
	end

	def home_news_edit
		@news = New.all
		@place = params[:place]
		@home_new = HomeNew.all.order('home_news.created_at DESC')[@place.to_i]

		render partial: "admin_home_news_edit"
	end

	def home_news_save

		# salvamos el crop
		@new = New.find(params[:home_new][:new_id])
		@new.crop_x2 = params[:crop_x].to_f
		@new.crop_y2 = params[:crop_y].to_f
		@new.crop_w2 = params[:crop_w].to_f
		@new.crop_h2 = params[:crop_h].to_f
		@new.save

		@home_new = HomeNew.find(params[:id])
		permitted_params = params.require(:home_new).permit(:new_id, :img_link)
		@home_new.update(permitted_params)

		image_str = @new.thumbnail.url(:display2)

		respond_to do |format|
		  format.json {
		    render json: ("image:" + image_str + ",place:" + params[:place]).to_json
		  }
		end
	end

	def home_news_clean
		@home_new = HomeNew.find(params[:id])
		@home_new.new = nil
		@home_new.remove_img_link!
		@home_new.save

		respond_to do |format|
		  format.json {
		    render json: ("ok").to_json
		  }
		end
	end

	# HOME
	# Carousel

	# GET
	def home_carousel
		if HomeCarousel.count == 0 
			first_carousel = HomeCarousel.new

			25.times { |count|
				carousel_element = first_carousel.carousel_elements.build
			}

			if first_carousel.save
				elements = first_carousel.carousel_elements
				first_carousel.head = elements.first.id

				elements.each.with_index do |elem, index|
					if index == 0
						elem.next = elements[(index + 1) % elements.length].id
						elem.previous = elements.last.id
					
					elsif index == (elements.length - 1)
						elem.next = elements.first.id
						elem.previous = elements[(index - 1) % elements.length].id
					
					else
						elem.next = elements[(index + 1) % elements.length].id
						elem.previous = elements[(index - 1) % elements.length].id
					end

					elem.save
				end
				
				first_carousel.save
			end
		end

		@carousels = HomeCarousel.all

		render partial: "admin_home_carousel"
	end

	# GET
	def new_home_carousel
		@carousel = HomeCarousel.new 
		25.times { |count|
			carousel_element = @carousel.carousel_elements.build
		}

		if @carousel.save
			elements = @carousel.carousel_elements
			@carousel.head = elements.first.id

			elements.each.with_index do |elem, index|
				if index == 0
					elem.next = elements[(index + 1) % elements.length].id
					elem.previous = elements.last.id
				
				elsif index == (elements.length - 1)
					elem.next = elements.first.id
					elem.previous = elements[(index - 1) % elements.length].id
				
				else
					elem.next = elements[(index + 1) % elements.length].id
					elem.previous = elements[(index - 1) % elements.length].id
				end

				elem.save
			end

			if @carousel.save
				respond_to do |format|
					format.json {
						render json: @carousel.to_json
					}
				end
			end
		end
	end

	# GET
	def edit_home_carousel
		@carousel = HomeCarousel.find(params[:id])
		@carousel_elements = @carousel.elements_inorder

		render partial: "admin_edit_home_carousel", locals: { carousel: @carousel, carousel_elements: @carousel_elements, count: params[:count] }
	end

	# DELETE
	def delete_home_carousel
		@carousel = HomeCarousel.find(params[:id])
		id_carousel = @carousel.id

		@carousel.destroy

		respond_to do |format|
			format.json {
				render json: id_carousel.to_json
			}
		end
	end

	# GET
	def carousel_elem_edit
		@carousel_element = CarouselElement.find(params[:id])
		@works = Work.all

		render partial: "admin_edit_carousel_element", locals: { carousel_element: @carousel_element, works: @works, div: params[:div] }
	end

	# PATCH
	def save_carousel_elem
		@carousel_element = CarouselElement.find(params[:id])

		@carousel_element.photo = params[:carousel_element][:photo]
		@carousel_element.x = params[:carousel_element][:x].to_f
		@carousel_element.y = params[:carousel_element][:y].to_f
		@carousel_element.w = params[:carousel_element][:w].to_f
		@carousel_element.h = params[:carousel_element][:h].to_f

		if @carousel_element.save
			info = { :image => Photo.find(@carousel_element.photo).image.url(:display),
						 :x => @carousel_element.x,
						 :y => @carousel_element.y,
						 :w => @carousel_element.w,
						 :h => @carousel_element.h }

			respond_to do |format|
				format.json {
					render json: info.to_json
				}
			end
		end
	end

	# POST
	def clean_carousel_elem
		@carousel_element = CarouselElement.find(params[:id])
		@carousel_element.photo = nil
		@carousel_element.x = nil
		@carousel_element.y = nil
		@carousel_element.w = nil
		@carousel_element.h = nil
		@carousel_element.save

		respond_to do |format|
			format.json {
				render json: "".to_json
			}
		end
	end

	# NOSOTROS

	# Quienes somos
	# GET
	def we_are_edit
		we_are = WebInfo.find_by_type_info("we_are")
		if we_are.nil?
			we_are = WebInfo.new
			we_are.type_info = "we_are"
			we_are.save
		end

		render partial: "admin_form_we_are", locals: { we_are: we_are }
	end

	# GET
	def we_do_edit
		we_do = WebInfo.find_by_type_info("we_do")
		if we_do.nil?
			we_do = WebInfo.new
			we_do.type_info = "we_do"
			we_do.save
		end

		render partial: "admin_form_we_do", locals: { we_do: we_do }
	end

	def list_projects_edit
		list_projects = WebInfo.find_by_type_info("list_projects")
		if list_projects.nil?
			list_projects = WebInfo.new
			list_projects.type_info = "list_projects"
			list_projects.save
		end

		render partial: "admin_form_list_projects", locals: { list_projects: list_projects }
	end

	# PATCH
	def webinfo_save
		web_info = WebInfo.find(params[:id])

		web_info.update(params.require(:web_info).permit(:body, :body_in_es, :body_in_en, :image))

		if web_info.type_info == "we_are"
			redirect_to we_are_path
		elsif web_info.type_info == "we_do"
			redirect_to we_do_path
		elsif web_info.type_info == "list_projects"
			redirect_to list_projects_path
		else
			redirect_to links_path
		end
	end

	# EXTRAS

	# Links
	# GET
	def links_edit
		links = WebInfo.find_by_type_info("links")
		if links.nil?
			links = WebInfo.new
			links.type_info = "links"
			links.save
		end

		render partial: "admin_form_links", locals: { links: links }
	end

	# Descargas
	def new_download
		@download = Download.new

		render partial: "admin_new_download"
	end

	def downloads
		@downloads = Download.all
		
		render partial: "admin_downloads"
	end

	# Noticias
	def new_new
		@new_ = New.new

		render partial: "admin_new_new"
	end

	def edit_new
		@new_ = New.find(params[:id])

		render partial: "admin_new_new"
	end

	def news
		@news = New.all.order(created_at: :desc)
		render partial: "admin_news"
	end

	### ADMIN PRENSA

	# GET
	def new_press_note
		@press_note = PressNote.new

		render partial: "admin_new_press_note"
	end

	# GET
	def edit_press_note
		@press_note = PressNote.find(params[:id])

		render partial: "admin_edit_press_note", locals: { press_note: @press_note }
	end

	# GET
	def press_notes
		@press_notes = PressNote.press_notes_inorder

		render partial: "admin_press_notes"
	end

end
