class WorksController < ApplicationController
	def show
		@work = Work.find(params[:id])
	end

	# GET
	def new
		@work = Work.new
	end

	# POST
	def create
		permitted_params = params.require(:work).permit(:type_work, :title, :titles_text, :titles_text_in_en, :credits, :credits_in_en,
			                             :synopsis, :synopsis_in_en, :notes, :notes_in_en, :program, :program_in_en, file_folders_attributes: [:name_folder, :ids_photos])

		@work = Work.new(post_params)
		
		if params[:work][:has_credits] == 0 and params[:work][:has_credits_in_en] == 0 
			@work.credits = nil
			@work.credits_in_en = nil
		end

		if params[:work][:has_synopsis] == 0 and params[:work][:has_synopsis_in_en] == 0 
			@work.synopsis = nil
			@work.synopsis_in_en = nil
		end

		if params[:work][:has_notes] == 0 and params[:work][:has_notes_in_en] == 0 
			@work.notes = nil
			@work.notes_in_en = nil
		end

		if params[:work][:has_program] == 0 and params[:work][:has_program_in_en] == 0 
			@work.program = nil
			@work.program_in_en = nil
		end

		if @work.save
			filefolder_params = permitted_params[:file_folders_attributes]

			filefolder_params.each do |key, value|
				name_filefolder = filefolder_params[key.to_s][:name_folder]
				currFolder = FileFolder.where(name_folder: name_filefolder.to_s, holdable_id: @work.id).first

				ids_photos = filefolder_params[key.to_s][:ids_photos]
				ids_photos.gsub! 'submitted', ''
				ids_photos.gsub! ' ', ''
				ids_photos_parse = ids_photos.split(',')

				ids_photos_parse.each do |id_photo|
					currPhoto = Photo.find(id_photo.to_i)
					currPhoto.file_folder = currFolder
					currPhoto.save

					if currFolder.display.nil?
						currFolder.display = id_photo
						currFolder.save
					end

					if @work.type_work == "minima_minima"
						if name_filefolder == "DEFAULT" and @work.display.nil?
							@work.display = id_photo
							@work.save
						end
					else
						if name_filefolder == "GALERIA" and @work.display.nil?
							@work.display = id_photo
							@work.save
						end
					end
				end
			end
		end
		
		redirect_to @work
	end

	def image_folder
		permitted_params = params.permit(:id, :folder)

		@work = Work.find(permitted_params[:id])
		image_folder = @work.file_folders.find_by_name_folder(permitted_params[:folder].to_s)
		photos = image_folder.photos.map { |p| p.image.url(:display) }

		respond_to do |format|
			format.json {
				render json: photos
			}
		end
	end

	private
		def post_params
			params.require(:work).permit(:type_work, :title, :titles_text, :titles_text_in_en, :credits, :credits_in_en,
			                             :synopsis, :synopsis_in_en, :notes, :notes_in_en, :program, :program_in_en, file_folders_attributes: [:name_folder])
		end
end
