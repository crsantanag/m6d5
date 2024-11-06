class PostulationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: [ :create ]
  before_action :set_postulation, only: %i[ show edit update destroy ]
  before_action :authorize_owner, only: [ :message ]

  before_action only: [ :destroy ] do
    authorize_request([ "normal", "owner", "admin" ])
  end

  def message
    @postulations = Postulation.where(saw: false)
  end

  # GET /postulations or /postulations.json
  def index
    @postulations = Postulation.where(user_id: current_user.id).order(created_at: :desc)
  end

  # GET /postulations/1 or /postulations/1.json
  def show
    @offer = Offer.find(@postulation.offer_id)
    # Si es el owner quien ve la postulación, entonces actualizo SAW de rojo a verde, es decir, de false a true
    if current_user.owner?
      @postulation.saw = true
      if !@postulation.save
        flash[:notice] = "Error interno - No es posible modificar VISTO"
      end
    end
  end

  # GET /postulations/new
  def new
    @postulation = Postulation.new
  end

  # GET /postulations/1/edit
  def edit
  end

  # POST /postulations or /postulations.json
  def create
    puts "Create - Postulation"
    # @postulation = Postulation.new(postulation_params)
    @postulation = @offer.postulations.build(postulation_params)

    if !user_signed_in?
      flash[:alert] = "DEBE INICIAR SESIÓN PARA POSTULAR"
      redirect_to root_path
      return
    elsif !current_user.curriculum.present? || !current_user.picture.attached?
      flash[:alert] = "DEBE INGRESAR SU CURRICULUM Y FOTO PARA POSTULAR"
      redirect_to offers_path
      return
    elsif Postulation.exists?(user_id: current_user.id, offer_id: @offer.id)
      puts current_user.id
      puts @offer.id
      flash[:alert] = "NO PUEDE POSTULAR AL MISMO CARGO MÁS DE 1 VEZ"
      redirect_to offers_path
      return
    end

    if user_signed_in? && @offer.present?
      @postulation.user_id = current_user.id
      @postulation.offer_id = @offer.id
    else
      flash[:alert] = "DEBE INICIAR SESIÓN PARA POSTULAR" # o bien, se eliminó la oferta de cargo
      redirect_to root_path
      return
    end

    respond_to do |format|
      if @postulation.save
        flash[:alert] = "POSTULACIÓN REALIZADA"
        format.html { redirect_to postulations_path }
        format.json { render :show, status: :created, location: @postulation }
      else
        format.html { render "offers/show", status: :unprocessable_entity }
        format.json { render json: @postulations.errors, status: :unprocessable_entity }
        logger.error @postulation.errors.full_messages
      end
    end
  end

  # PATCH/PUT /postulations/1 or /postulations/1.json
  def update
    @postulation.saw = false  # Cambio a false para que Esteban García lea nuevamente el mensaje
    respond_to do |format|
      if @postulation.update(postulation_params)
        flash[:alert] = "POSTULACIÓN ACTUALIZADA"
        format.html { redirect_to @postulation }
        format.json { render :show, status: :ok, location: @postulation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @postulation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postulations/1 or /postulations/1.json
  def destroy
    @postulation = Postulation.find(params[:id])

    # Aquí revisar si quien desea eliminar la postulación sea el dueño de la misma
    # Esto pq puede haber más de un owner o administrador

    respond_to do |format|
      if @postulation.destroy!
        flash[:alert] = "POSTULACIÓN ELIMINADA"
        if current_user&.owner? || current_user&.admin?
           format.json { head :no_content }
           format.html { redirect_to contest_offers_path }
        else
          format.json { head :no_content }
          format.html { redirect_to postulations_path }
        end
      else
        logger.error @postulation.errors.full_messages
        format.html { redirect_to postulations_path, notice: "** Postulación no pudo ser eliminada **" }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_postulation
      puts "Set postulation - Postulation"
      @postulation = Postulation.find_by(id: params[:id])

      if !@postulation
        flash[:alert] = "LA POSTULACIÓN NO SE ENCONTRÓ O FUE ELIMINADA"
        redirect_to offers_path
      end
    end

    def set_offer
      puts "Set_offer - Postulation"
      offer_id = params[:offer_id]
      puts "Offer ID: #{offer_id}"
      @offer = Offer.find(params[:offer_id]) # La oferta debe existir para postular
      if !@offer
        flash[:alert] = "LA OFERTA NO SE ENCONTRÓ O FUE ELIMINADA"
        redirect_to offers_path
      end
    end

    def authorize_owner
      puts "Authorize Owner - Postulation"
      unless current_user&.owner? || current_user&.admin?
        flash[:alert] = "USUARIO NO AUTORIZADO"
        redirect_to root_path
      end
    end

    # Only allow a list of trusted parameters through.
    def postulation_params
      puts "Postulation Params - Postulation"
      params.require(:postulation).permit(:message, :saw, :user_id, :offer_id)
    end
end
