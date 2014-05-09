class PressNotesController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [:create]
	before_filter :authenticate_user!, :only => [ :create, :new, :edit_elements, :save_element ]

	def index
		@press_notes = PressNote.all
	end

	def new
		@press_note = PressNote.new
	end

	def create
		@press_note = PressNote.new(press_params)
		10.times do |count|
			@press_note.press_elements.build
		end
		@press_note.save

		respond_to do |format|
			format.json {
				render json: (@press_note.id.to_s).to_json
			}
		end
	end

	def edit_elements
		@press_note = PressNote.find(params[:id])

		render partial: "press_notes/edit_elements", locals: { press_note: @press_note }
	end

	def save_element
		@press_element = PressElement.find(params[:id])
		@press_element.body = params["body" + params[:id].to_s]["ckeditor"]
		@press_element.save

		respond_to do |format|
			format.json {
				render json: (@press_element.id.to_s).to_json
			}
		end
	end

	def press_element
		@press_element = PressElement.find(params[:id])
		
		respond_to do |format|
			format.json {
				render json: @press_element.body.html_safe
			}
		end
	end

	private
		def press_params
			params.require(:press_note).permit(:title, :background)
		end
end
