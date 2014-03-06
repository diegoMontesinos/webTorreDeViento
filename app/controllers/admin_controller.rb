class AdminController < ApplicationController

	before_filter :authenticate_user!
	skip_before_filter :verify_authenticity_token, :only => [:save_colab_gridelem]

	# GET
	def show
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

	# POST
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
			permitted_params = params.require(:colaborator_grid_element).permit(:sprocket, :accessFrequent)
			
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

end
