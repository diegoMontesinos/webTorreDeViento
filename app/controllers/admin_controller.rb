class AdminController < ApplicationController

	before_filter :authenticate_user!

	# GET
	def show
	end

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
	def work_grid_edit
		@work_grid = WorkGrid.find(params[:id])
		@grid_elements = @work_grid.grid_elements

		render partial: "admin_edit_work_grid", locals: { work_grid: @work_grid, grid_elements: @grid_elements }
	end

	# GET
	def work_grid_elem_edit
		@grid_element = GridElement.find(params[:id])
		@works = Work.all

		render partial: "admin_edit_grid_element", locals: { grid_element: @grid_element, works: @works }
	end

	# GET
	def works
		@works = Work.works_inorder

		render partial: "admin_works"
	end

end
