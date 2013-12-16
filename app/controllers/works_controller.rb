class WorksController < ApplicationController

	def show
		@work = Work.find(params[:id])
	end

	def new
	end

	def create
		@work = Work.new(post_params)
		@work.save
		
		redirect_to @work
	end

	private
		def post_params
			params.require(:work).permit(:type_work, :title, :subtitle, :description, :title_in_en, :subtitle_in_en, :description_in_en)
		end
end
