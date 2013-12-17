class WorksController < ApplicationController
	def show
		@work = Work.find(params[:id])
	end

	def new
	end

	def create
		@work = Work.new(post_params)
		
		if params[:work][:has_credits] == 0
			@work.credits = nil
			@work.credits_in_en = nil
		end

		if params[:work][:has_synopsis] == 0
			@work.synopsis = nil
			@work.synopsis_in_en = nil
		end

		if params[:work][:has_notes] == 0
			@work.notes = nil
			@work.notes_in_en = nil
		end

		if params[:work][:has_program] == 0
			@work.program = nil
			@work.program_in_en = nil
		end

		@work.save
		
		redirect_to @work
	end

	private
		def post_params
			params.require(:work).permit(:type_work, :title, :titles_text, :titles_text_in_en, :credits, :credits_in_en,
			                             :synopsis, :synopsis_in_en, :notes, :notes_in_en, :program, :program_in_en)
		end
end
