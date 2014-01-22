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

		render partial: "works/form_new_work", locals: { work: @work }
	end

	# GET
	def works_catalog
		render partial: "admin_works_catalog"
	end

	# GET
	def works
		@works = Work.works_inorder

		render partial: "admin_works"
	end

end
