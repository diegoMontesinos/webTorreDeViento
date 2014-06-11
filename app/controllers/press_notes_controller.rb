class PressNotesController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [:create]
	before_filter :authenticate_user!, :only => [ :create, :new, :edit_elements, :save_element ]

	def index
		@press_notes = PressNote.press_notes_inorder
	end

	def new
		@press_note = PressNote.new
	end

	def create
		@press_note = PressNote.new(press_params)
		10.times do |count|
			@press_note.press_elements.build
		end

		@press_note.next = -1
		@press_note.previous = -1

		if @press_note.save

			# Si solo hay una
			if PressNote.count > 1
				press_notes_inorder = PressNote.press_notes_inorder

				# Se inserta al final
				press_notes_inorder.last.next = @press_note.id
				@press_note.previous = press_notes_inorder.last.id
				press_notes_inorder.last.save

				@press_note.save
			end

			respond_to do |format|
				format.json {
					render json: (@press_note.id.to_s).to_json
				}
			end
		end
		
	end

	# DELETE
	def destroy
		@press_note = PressNote.find(params[:id])
		id_press = @press_note.id
		@press_note.destroy

		respond_to do |format|
			format.json {
				render json: id_press.to_json
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

	def update
		@press_note = PressNote.find(params[:id])

		if @press_note.save(press_params)
			respond_to do |format|
				format.json {
					render json: (@press_note.id.to_s).to_json
				}
			end
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

	# POST
	def store_order
		
		ordered_ids = params[:order].split('_')
		index = 0

		while (index < ordered_ids.length) do
			curr_press = PressNote.find(ordered_ids[index].to_i)

			# Es el primero
			if index == 0
				curr_press.previous = -1

				if (index + 1) < ordered_ids.length
					curr_press.next = ordered_ids[index + 1].to_i
				else
					curr_press.next = -1
				end

			# Es el ultimo
			elsif index == (ordered_ids.length - 1)
				curr_press.next = -1

				if (index - 1) >= 0
					curr_press.previous = ordered_ids[index - 1].to_i
				else
					curr_press.previous = -1
				end

			# Esta en medio
			else
				curr_press.next = ordered_ids[index + 1].to_i
				curr_press.previous = ordered_ids[index - 1].to_i
			end

			curr_press.save
			index += 1
		end

		respond_to do |format|
			format.json {
				render json: params[:order].to_json
			}
		end
	end

	private
		def press_params
			params.require(:press_note).permit(:title, :background)
		end
end
