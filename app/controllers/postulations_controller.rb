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
    # Aquí actualizo SAW de rojo a verde ,  es decir, de false a true
    if current_user.owner?
      @postulation.saw = true
      if !@postulation.save
        flash[:notice] = "Error interno - No es posible modificar SAW"
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
    @postulation = Postulation.new(postulation_params)

    if !user_signed_in?
      redirect_to root_path, notice: "DEBE INICIAR SESIÓN PARA POSTULAR"
      return
    elsif !@offer.present?
      redirect_to offers_path, notice: "No existe la oferta de cargo ** Error interno **"
      return
    elsif Postulation.exists?(user_id: current_user.id, offer_id: @offer.id)
      puts "current_user.id " + current_user.id.to_s
      puts "offer.id        " + @offer.id.to_s
      redirect_to offer_path(@offer.id), notice: "UD. YA POSTULÓ A ESTE CARGO. REVISE SUS POSTULACIONES"
      return
    end

    if user_signed_in? && @offer.present?
      @postulation.user_id = current_user.id
      @postulation.offer_id = @offer.id
    else
      redirect_to root_path, notice: "DEBE INICIAR SESIÓN PARA POSTULAR"
      return
    end

    respond_to do |format|
      if @postulation.save
        format.html { redirect_to postulations_path, notice: "POSTULACIÓN REALIZADA" }
        format.json { render :show, status: :created, location: @postulation }
      else
        logger.error @postulation.errors.full_messages
        format.html { redirect_to offer_path(@offer.id), notice: "Postulación no pudo ser realizada ** Error en interno **" }
        format.json { render json: @postulation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /postulations/1 or /postulations/1.json
  def update
    @postulation.saw = false  # Cambio a false para que Esteban Steele lea nuevamente wl mensaje
    respond_to do |format|
      if @postulation.update(postulation_params)
        format.html { redirect_to @postulation, notice: "POSTULACIÓN ACTUALIZADA" }
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

    respond_to do |format|
      if @postulation.destroy!
        format.html { redirect_to postulations_path, notice: "POSTULACION ELIMINADA" }
        format.json { head :no_content }
      else
        logger.error @postulation.errors.full_messages
        format.html { redirect_to postulations_path, notice: "** Postulación no pudo ser eliminada **" }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_postulation
      @postulation = Postulation.find(params[:id])         # La postulación debe existir para [ show edit update destroy ]
    end

    def set_offer
      @offer = Offer.find(params[:postulation][:offer_id])  # La oferta debe existir para postular
    end

    def authorize_owner
      unless current_user&.owner? || current_user&.admin?
        redirect_to root_path, notice: "NO ESTÁ AUTORIZADO PARA ACCEDER A ESTA PÁGINA"
      end
    end

    # Only allow a list of trusted parameters through.
    def postulation_params
      params.require(:postulation).permit(:message, :saw, :user_id, :offer_id)
    end
end
