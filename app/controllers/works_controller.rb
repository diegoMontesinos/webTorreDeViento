# encoding: utf-8 

class WorksController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [:create]
	before_filter :authenticate_user!, :only => [ :edit_images, :edit_folders, :edit_display, :edit_folder, :edit_videothumb, :save_display, :save_folder, :save_videothumb, :new, :create, :destroy ]
	
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

			if Work.count == 1
				@work.next = @work.id
				@work.previous = @work.id
			else
				works_inorder = Work.works_inorder

				# Editando el ultimo
				works_inorder.last.next = @work.id
				@work.previous = works_inorder.last.id
				works_inorder.last.save

				# Editando el primero
				works_inorder.first.previous = @work.id
				@work.next = works_inorder.first.id
				works_inorder.first.save
			end
			
			if @work.save

				# Se agregan las fotos que fueron subidas
				filefolder_params = params[:work][:file_folders_attributes]

				filefolder_params.each do |key, value|

					name_filefolder = filefolder_params[key.to_s][:name_folder]
					puts "name_FOLDER::::: " + name_filefolder.to_s
					saved_folders = FileFolder.where(holdable_id: @work.id)

					saved_folders.reject { |folder| folder.name_folder_in_es == name_filefolder }
					currFolder = saved_folders.first

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
								currFolder.name_folder_in_es = "GALERÍA"
								currFolder.save
								
								@work.display = id_photo
								@work.save
							end
						end
					end
				end
			end
		end

		if @work.type_work == "full" and @work.video.present?
			respond_to do |format|
				format.json {
					render json: ("remotipart" + @work.id.to_s).to_json
				}
			end
		else
			redirect_to edit_images_path + "/?id=" + @work.id.to_s
		end
	end

	# PUT
	def update
		@work = Work.find(params[:id])

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

		# Si la obra se salvo bien
		if @work.update(permitted_params)

			# Se agregan las fotos que fueron subidas
			filefolder_params = params[:work][:file_folders_attributes]

			if !filefolder_params.nil?
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
								currFolder.name_folder_in_es = "GALERÍA"
								currFolder.save

								@work.display = id_photo
								@work.save
							end
						end
					end
				end
			end
		end

		if @work.type_work == "full" and @work.video.present?
			respond_to do |format|
				format.json {
					render json: ("remotipart" + @work.id.to_s).to_json
				}
			end
		else
			redirect_to edit_images_path + "/?id=" + @work.id.to_s
		end
	end

	# DELETE
	def destroy
		@work = Work.find(params[:id])
		id_work = @work.id
		@work.destroy

		respond_to do |format|
			format.json {
				render json: id_work.to_json
			}
		end
	end

	# POST
	def add_images
		filefolder = FileFolder.find(params[:id])
		ids_photos = params["ids_photos_" + params[:id].to_s]
		ids_photos.gsub! '{:value=>:submitted}', ''
		ids_photos.gsub! ' ', ''
		ids_photos_parse = ids_photos.split(',')
		ids_photos_parse.each do |id_photo|
			photo = Photo.find(id_photo.to_i)
			photo.file_folder = filefolder
			photo.save
		end

		respond_to do |format|
			format.json {
				render json: filefolder.id.to_json
			}
		end
	end

	# GET
	def index
	end

	def index_desktop
		@work_grids = WorkGrid.all

		render partial: "index_desktop"
	end

	def index_mobile
		@work_grids = WorkGrid.all

		render partial: "index_mobile"
	end

	def image_folder
		permitted_params = params.permit(:id, :folder)

		@work = Work.find(permitted_params[:id])
		image_folder = @work.filefolder(permitted_params[:folder].to_s)
		photos = image_folder.photos.map { |p| p.image.url(:display) }

		respond_to do |format|
			format.json {
				render json: photos
			}
		end
	end

	# GET
	def images_folder
		file_folder = FileFolder.find(params[:id])

		respond_to do |format|
			format.json {
				render json: file_folder.photos.to_json
			}
		end
	end

	# GET
	def images
		work = Work.find(params[:id])
		folders = work.file_folders
		photos = Array.new

		folders.each do |folder|
			photos = photos + folder.photos
		end

		respond_to do |format|
			format.json {
				render json: photos
			}
		end
	end

	# GET
	def edit_images
		@work = Work.find(params[:id])

		if @work.type_work == "full"
			render partial: "works/edit_images/edit_images_full", locals: { work: @work }
 		elsif @work.type_work == "mediana"
			render partial: "works/edit_images/edit_images_mediana", locals: { work: @work }
 		elsif @work.type_work == "minima"
			render partial: "works/edit_images/edit_images_minima", locals: { work: @work }
 		else
			render partial: "works/edit_images/edit_images_minima_minima", locals: { work: @work }
 		end
	end

	# GET
	def edit_folders
		@work = Work.find(params[:id])
		render partial: "works/edit_folders", locals: { work: @work }
	end


	# GET
	def edit_display
		@work = Work.find(params[:id])

		render partial: "works/edit_images/edit_display", locals: { work: @work, id_div: params[:id_div] }
	end

	# POST
	def save_display
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

	# GET
	def edit_folder
		@file_folder = FileFolder.find(params[:id])
		@work = @file_folder.holdable

		@dimensions = { :w => nil, :h => nil }
		if @work.type_work == "full"
			@dimensions[:w] = 248.0
			@dimensions[:h] = 150.0
		elsif @work.type_work == "mediana"
			@dimensions[:w] = 299.0
			@dimensions[:h] = 150.0
		end

		render partial: "works/edit_images/edit_file_folder", locals: { work: @work, file_folder: @file_folder, id_div: params[:id_div], dimensions: @dimensions }
	end

	# POST
	def save_folder
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

	# GET
	def edit_videothumb
		@work = Work.find(params[:id])

		render partial: "works/edit_images/edit_videothumb", locals: { work: @work, id_div: params[:id_div] }
	end

	# POST
	def save_videothumb
		@work = Work.find(params[:id])
		@work.crop_x = params[:crop_x]
		@work.crop_y = params[:crop_y]
		@work.crop_w = params[:crop_w]
		@work.crop_h = params[:crop_h]

		@work.save

		image_str = @work.videothumb.url(:display_folder)

		respond_to do |format|
			format.json {
				render json: image_str.to_json
			}
		end
	end

	# POST
	def store_order

		ordered_ids = params[:order].split('_')
		index = 0

		while (index < ordered_ids.length) do
			curr_work = Work.find(ordered_ids[index].to_i)

			if index == 0
				curr_work.next = ordered_ids[(index + 1) % ordered_ids.length].to_i
				curr_work.previous = ordered_ids.last.to_i
			elsif index == (ordered_ids.length - 1)
				curr_work.next = ordered_ids.first.to_i
				curr_work.previous = ordered_ids[(index - 1) % ordered_ids.length].to_i
			else
				curr_work.next = ordered_ids[(index + 1) % ordered_ids.length].to_i
				curr_work.previous = ordered_ids[(index - 1) % ordered_ids.length].to_i
			end

			curr_work.save
			index += 1
		end

		respond_to do |format|
			format.json {
				render json: params[:order].to_json
			}
		end
	end

	private
		def work_params
			params.require(:work).permit(:type_work, :title, :titles_text, :titles_text_in_es, :titles_text_in_en, :titles_grid, :titles_grid_in_es, :titles_grid_in_en,
										 :credits, :credits_in_es, :credits_in_en, :synopsis, :synopsis_in_es, :synopsis_in_en, :notes, :notes_in_es, :notes_in_en, :program,
										 :program_in_es, :program_in_en, :video, :videothumb, file_folders_attributes: [:name_folder, :name_folder_in_en, :name_folder_in_es])
		end
end
