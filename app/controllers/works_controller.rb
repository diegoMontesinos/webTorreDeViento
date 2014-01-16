class WorksController < ApplicationController

	# GET
	def show
		@work = Work.find(params[:id])
	end

	# GET
	def new
		@work = Work.new
	end

	# POST
	def create
		permitted_params = work_params # Parametros filtrados (permitidos)

		# Setea a nil la informacion (esp y en) si se indico que no hay
		if params[:work][:has_credits].to_i == 0 and params[:work][:has_credits_in_en].to_i == 0
			permitted_params[:credits] = nil
			permitted_params[:credits_in_en] = nil
		end

		if params[:work][:has_synopsis].to_i == 0 and params[:work][:has_synopsis_in_en].to_i == 0 
			permitted_params[:synopsis] = nil
			permitted_params[:synopsis_in_en] = nil
		end

		if params[:work][:has_notes].to_i == 0 and params[:work][:has_notes_in_en].to_i == 0 
			permitted_params[:notes] = nil
			permitted_params[:notes_in_en] = nil
		end

		if params[:work][:has_program].to_i == 0 and params[:work][:has_program_in_en].to_i == 0 
			permitted_params[:program] = nil
			permitted_params[:program_in_en] = nil
		end

		# Setea a nil el video si se indico que no hay
		if params[:work][:has_video].to_i == 0
			permitted_params[:video] = nil
			permitted_params[:videothumb] = nil
		end

		@work = Work.new(permitted_params)

		# Si la obra se salvo bien
		if @work.save
			# Se agregan las fotos que fueron subidas
			filefolder_params = params[:work][:file_folders_attributes]

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

		redirect_to edit_images_path(@work.id)
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

	def edit_images
		@work = Work.find(params[:id])

		if @work.type_work == "full"
	 		render partial: "works/edit_images/edit_images_full"
		elsif @work.type_work == "mediana"
	 		render partial: "works/edit_images/edit_images_mediana"
		elsif @work.type_work == "minima"
	 		render partial: "works/edit_images/edit_images_minima"
		else
	 		render partial: "works/edit_images/edit_images_minima_minima"
		end
	end

	# POST
	def edit_display
		@work = Work.find(params[:id])

		@work.update_attribute(:display, params[:display].to_i)
		@work.save
		image_str = Photo.find(params[:display].to_i).image.url(:display)

		respond_to do |format|
			format.json {
				render json: image_str.to_json
			}
		end
	end

	# POST
	def edit_folder
		@file_folder = FileFolder.find(params[:id_folder])
		@file_folder.update_attribute(:display, params[:display].to_i)
		@file_folder.crop_x = params[:crop_x]
		@file_folder.crop_y = params[:crop_y]
		@file_folder.crop_w = params[:crop_w]
		@file_folder.crop_h = params[:crop_h]

		@file_folder.save

		image_str = Photo.find(params[:display].to_i).image.url(:display_folder)

		respond_to do |format|
			format.json {
				render json: image_str.to_json
			}
		end
		
	end

	private
		def work_params
			params.require(:work).permit(:type_work, :title, :titles_text, :titles_text_in_en, :credits, :credits_in_en,
										 :synopsis, :synopsis_in_en, :notes, :notes_in_en, :program, :program_in_en, :video, :videothumb, file_folders_attributes: [:name_folder])
		end
end
