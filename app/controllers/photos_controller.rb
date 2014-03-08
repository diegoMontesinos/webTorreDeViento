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
		idPhoto = photo.id
		Photo.destroy(params[:id])

		respond_to do |format|
			format.json { render json: idPhoto }
		end
	end

	private
	
	def photo_params
		params.permit(:image)
	end
end
