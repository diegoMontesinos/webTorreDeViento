class ColaboratorsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]
  before_filter :authenticate_user!, :only => [ :new, :create ]

  def index
  end

  # POST
  def create
    permitted_params = colaborator_params # Parametros filtrados (permitidos)

    @colaborator = Colaborator.new(permitted_params)
    @colaborator.save
    
    redirect_to @colaborator
  end

  # GET
  def new
    @colaborator = Colaborator.new
  end

  def edit
  end

  def show
    @colaborator = Colaborator.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private
    def colaborator_params
      params.require(:colaborator).permit(:name, :title, :cv_text, :semblance_text, :cv_text_in_en, :semblance_text_in_en,
                                          :cv, :semblance, :frequent, :cv_en, :semblance_en, :sproket_1, :sproket_2, :portrait)
    end
end
