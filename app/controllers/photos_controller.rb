class PhotosController < ApplicationController

	# POST
	def create
		@photo = Photo.new(photo_params)
		@photo.save

		respond_to do |format|
			format.json { render json: @photo.id }
		end
	end

	# POST
	def destroy
		photo = Photo.find(params[:id])
		file_folder = photo.file_folder
		idPhoto = photo.id

		if file_folder.photos.count > 1
			Photo.destroy(params[:id])

			respond_to do |format|
				format.json { render json: idPhoto }
			end
		end
	end

	private
	
	def photo_params
		params.permit(:image)
	end
end
