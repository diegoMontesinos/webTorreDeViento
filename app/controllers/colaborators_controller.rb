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

    if @colaborator.save

      @colaborator.next_frequent = -1
      @colaborator.previous_frequent = -1

      if params[:colaborator][:frequent].to_i == 1
        
        # Si soy el unico
        if Colaborator.frequents_colaborators.length > 1
          frequents_inorder = Colaborator.frequents_inorder

          # Se inserta al final
          frequents_inorder.last.next_frequent = @colaborator.id
          @colaborator.previous_frequent = frequents_inorder.last.id
          frequents_inorder.last.save

        end
      end

      @colaborator.save
      redirect_to @colaborator
    end

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
    permitted_params = colaborator_params # Parametros filtrados (permitidos)

    @colaborator = Colaborator.find(params[:id])

    if @colaborator.frequent

      # si es colaborador frecuente y deja de serlo hay q sacarlo de la lista
      if params[:colaborator][:frequent].to_i == 0

        id_prev = @colaborator.previous_frequent
        id_next = @colaborator.next_frequent

        # Obtenemos los vecinos
        p = -1
        if id_prev != -1
          p = Colaborator.find_by_id(id_prev)
          id_prev = p.id
        end
        
        n = -1
        if id_next != -1
          n = Colaborator.find_by_id(id_next)
          id_next = n.id
        end

        # Los alteramos
        if p != -1
          p.next_frequent = id_next
          p.save
        end

        if n != -1
          n.previous_frequent = id_prev
          n.save
        end

        # Borramos las referencias
        @colaborator.next_frequent = -1
        @colaborator.previous_frequent = -1
        @colaborator.save
      end

    else
      
      # o no lo es y ya es frecuente hay que meterlo
      if params[:colaborator][:frequent].to_i == 1
        
        # Si soy el unico
        if Colaborator.frequents_colaborators.length > 1
          frequents_inorder = Colaborator.frequents_inorder

          # Se inserta al final
          frequents_inorder.last.next_frequent = @colaborator.id
          @colaborator.previous_frequent = frequents_inorder.last.id
          frequents_inorder.last.save

          @colaborator.save
        else
          # Borramos las referencias
          @colaborator.next_frequent = -1
          @colaborator.previous_frequent = -1
          @colaborator.save
        end

      end

    end
    
    @colaborator.update(permitted_params)
    
    redirect_to @colaborator
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
    @frequents_colaborators = Colaborator.frequents_inorder
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

  # POST
  def store_order_frequents

    ordered_ids = params[:order].split('_')
    index = 0

    while (index < ordered_ids.length) do
      curr_frequent = Colaborator.find(ordered_ids[index].to_i)

      # Es el primero
      if index == 0
        curr_frequent.previous_frequent = -1

        if (index + 1) < ordered_ids.length
          curr_frequent.next_frequent = ordered_ids[index + 1].to_i
        else
          curr_frequent.next_frequent = -1
        end

      # Es el ultimo
      elsif index == (ordered_ids.length - 1)
        curr_frequent.next_frequent = -1

        if (index - 1) >= 0
          curr_frequent.previous_frequent = ordered_ids[index - 1].to_i
        else
          curr_frequent.previous_frequent = -1
        end

      # Esta en medio
      else
        curr_frequent.next_frequent = ordered_ids[index + 1].to_i
        curr_frequent.previous_frequent = ordered_ids[index - 1].to_i
      end

      curr_frequent.save
      index += 1
    end

    respond_to do |format|
      format.json {
        render json: params[:order].to_json
      }
    end
  end

  private
    def colaborator_params
      params.require(:colaborator).permit(:name, :title, :cv_text, :semblance_text, :cv_text_in_en, :cv_text_in_es, :semblance_text_in_en, :semblance_text_in_es,
                                          :cv, :semblance, :frequent, :cv_en, :semblance_en, :sproket_1, :sproket_2, :portrait)
    end
end
