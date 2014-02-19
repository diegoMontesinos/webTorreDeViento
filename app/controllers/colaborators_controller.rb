class ColaboratorsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]
  before_filter :authenticate_user!, :only => [ :new, :create, :destroy ]

  def index
    if ColaboratorGridElement.count == 0
      28.times { |count|
        colab_grid_element = ColaboratorGridElement.new
        colab_grid_element.box = count.to_s

        colab_grid_element.save
      }
    end
    
    @colaborator_grid_elements = ColaboratorGridElement.all
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

  # GET
  def edit
  end

  def show
    @colaborator = Colaborator.find(params[:id])

    if @colaborator.frequent
      
      if params[:previous].present?
        @colaborator.previous = params[:previous].to_i
      else
        @colaborator.previous = @colaborator.id
      end

      if params[:next].present?
        @colaborator.next = params[:next].to_i
      else
        @colaborator.next = @colaborator.id
      end
      
    else
      colaborators = Colaborator.colaborators_inorder

      colaborators.each.with_index { |colab, index|
        if colab.is_a? Colaborator
          if colab.id == @colaborator.id

            if index - 1 >= 0
              if colaborators[index - 1].is_a? Colaborator
                @colaborator.previous = colaborators[index - 1].id
              else
                @colaborator.previous = "-1"
              end
            else
              if colaborators[colaborators.length - 1].is_a? Colaborator
                @colaborator.previous = colaborators[colaborators.length - 1].id
              else
                @colaborator.previous = "-1"
              end
            end

            if index + 1 < colaborators.length
              if colaborators[index + 1].is_a? Colaborator
                @colaborator.next = colaborators[index + 1].id
              else
                @colaborator.next = "-1"
              end
            else
              if colaborators[0].is_a? Colaborator
                @colaborator.next = colaborators[0].id
              else
                @colaborator.next = "-1"
              end
            end

            break
          end
        end
      }

    end

  end

  # PATCH
  def update
    @colaborator = Colaborator.find(params[:id])

    if @colaborator.frequent
      
      if params[:previous].present?
        @colaborator.previous = params[:previous].to_i
      else
        @colaborator.previous = @colaborator.id
      end

      if params[:next].present?
        @colaborator.next = params[:next].to_i
      else
        @colaborator.next = @colaborator.id
      end
      
    else
      colaborators = Colaborator.colaborators_inorder

      colaborators.each.with_index { |colab, index|
        if colab.is_a? Colaborator
          if colab.id == @colaborator.id

            if index - 1 >= 0
              if colaborators[index - 1].is_a? Colaborator
                @colaborator.previous = colaborators[index - 1].id
              else
                @colaborator.previous = "-1"
              end
            else
              if colaborators[colaborators.length - 1].is_a? Colaborator
                @colaborator.previous = colaborators[colaborators.length - 1].id
              else
                @colaborator.previous = "-1"
              end
            end

            if index + 1 < colaborators.length
              if colaborators[index + 1].is_a? Colaborator
                @colaborator.next = colaborators[index + 1].id
              else
                @colaborator.next = "-1"
              end
            else
              if colaborators[0].is_a? Colaborator
                @colaborator.next = colaborators[0].id
              else
                @colaborator.next = "-1"
              end
            end

            break
          end
        end
      }

    end
  end

  # DELETE
  def destroy
    @colaborator = Colaborator.find(params[:id])
    id_colaborator = @colaborator.id
    @colaborator.destroy

    respond_to do |format|
      format.json {
        render json: id_colaborator.to_json
      }
    end
  end

  def frequents
    @frequents_colaborators = Colaborator.frequents_colaborators
    colaborators = Colaborator.colaborators_inorder

    colaborators.each.with_index { |colab, index|
      if colab.is_a? String

        if index - 1 >= 0
          @previous = colaborators[index - 1].id
        else
          @previous = colaborators[colaborators.length - 1].id
        end

        if index + 1 < colaborators.length
          @next = colaborators[index + 1].id
        else
          @next = colaborators[0].id
        end

        break
      end
    }
  end

  private
    def colaborator_params
      params.require(:colaborator).permit(:name, :title, :cv_text, :semblance_text, :cv_text_in_en, :semblance_text_in_en,
                                          :cv, :semblance, :frequent, :cv_en, :semblance_en, :sproket_1, :sproket_2, :portrait)
    end
end
