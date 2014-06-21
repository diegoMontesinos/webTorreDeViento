class DownloadsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => [:create]
  before_filter :authenticate_user!, :only => [ :new, :create, :edit_thumbnail]

  # GET
  def new
    @download = Download.new
  end

  # POST
  def create
  	permitted_params = download_params # Parametros filtrados (permitidos)

  	@download = Download.new(permitted_params)
  	@download.save
    
    respond_to do |format|
      format.json {
        render json: (@download.id.to_s).to_json
      }
    end
  end

  # GET
  def index
    @downloads = Download.all
  end

  # DELETE
  def destroy
    @download = Download.find(params[:id])
    id_download = @download.id
    @download.destroy

    respond_to do |format|
      format.json {
        render json: id_download.to_json
      }
    end
  end

  # GET
  def edit_thumbnail
    @download = Download.find(params[:id])

    render partial: "downloads/edit_thumbnail", locals: { download: @download }
  end

  # POST
  def save_thumbnail
    @download = Download.find(params[:id]) #base de datos
    @download.crop_x = params[:crop_x]
    @download.crop_y = params[:crop_y]
    @download.crop_w = params[:crop_w]
    @download.crop_h = params[:crop_h]

    @download.save

    image_str = @download.thumbnail.url(:normalize)

    respond_to do |format|
      format.json {
        render json: image_str.to_json
      }
    end
  end

  private
		def download_params
			params.require(:download).permit(:title, :attachment, :thumbnail)
		end
end
