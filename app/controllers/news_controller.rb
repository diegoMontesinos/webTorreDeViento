class NewsController < ApplicationController

	skip_before_filter :verify_authenticity_token, :only => [:create]
	before_filter :authenticate_user!, :only => [ :new, :create ]

	def index
		@news = New.all
	end

	# GET
	def new
		@new_ = New.new
	end

	# POST
	def create
	  permitted_params = new_params # Parametros filtrados (permitidos)

	  @new = New.new(permitted_params)
	  @new.home = -1
	  @new.save

	  respond_to do |format|
	  format.json {
	    render json: (@new.id.to_s).to_json
	  }
	  end
	end

	# GET
	def edit_thumbnail
	  @new = New.find(params[:id])

	  render partial: "news/edit_thumbnail", locals: { new_: @new }
	end

	# POST
	def save_thumbnail
	  @new = New.find(params[:id])
	  @new.crop_x1 = params[:crop_x]
	  @new.crop_y1 = params[:crop_y]
	  @new.crop_w1 = params[:crop_w]
	  @new.crop_h1 = params[:crop_h]

	  @new.save

	  image_str = @new.thumbnail.url(:normalize)

	  respond_to do |format|
	    format.json {
	      render json: image_str.to_json
	    }
	  end
	end

	def show
		url_new = "new_" + params[:id]
		render partial: url_new
	end

	private
		def new_params
			params.require(:new).permit(:title, :image_new, :thumbnail)
		end
end
