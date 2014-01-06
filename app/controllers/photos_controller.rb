class PhotosController < ApplicationController
	def create
		@photo = Photo.new(photo_params)
		@photo.save

		respond_to do |format|
			format.json { render json: @photo.id }
		end
	end

	private
	
	def photo_params
		params.permit(:image)
	end
end
