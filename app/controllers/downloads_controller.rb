class DownloadsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => [:create]
  before_filter :authenticate_user!, :only => [ :create ]

  def create
  	permitted_params = download_params # Parametros filtrados (permitidos)

  	@download = Download.new(permitted_params)
  	@download.save
  end

  def index
    @downloads = Download.all
  end

  private
		def download_params
			params.require(:download).permit(:title, :attachment, :thumbnail)
		end
end
