class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: %i[ show edit update destroy ]
  before_action :authorize_owner, only: [ :contest ]

  before_action only: [ :new, :create, :edit, :update, :destroy ] do
    authorize_request([ "owner", "admin" ])
  end

  def contest
    @offers = Offer.order(created_at: :desc)
  end

  # GET /offers or /offers.json
  def index
    @postulation = Postulation.new
    if current_user.owner? ||  current_user.admin?
      @offers = Offer.order(created_at: :desc)
    elsif current_user.normal?
      @offers = Offer.where(active: true).order(created_at: :desc)
    end
  end

  # GET /offers/1 or /offers/1.json
  def show
    @postulation = Postulation.new
  end

  # GET /offers/new
  def new
    @offer = Offer.new
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers or /offers.json
  def create
    @offer = Offer.new(offer_params)
    @offer.user_id = current_user.id

    respond_to do |format|
      if @offer.save
        format.html { redirect_to @offer, notice: "Oferta de cargo creada" }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1 or /offers/1.json
  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to @offer, notice: "Oferta de cargo actualizada" }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1 or /offers/1.json
  def destroy
    @offer.destroy!

    respond_to do |format|
      format.html { redirect_to offers_path, status: :see_other, notice: "Oferta de cargo eliminada" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    def authorize_owner
      unless current_user&.owner? || current_user&.admin?
        redirect_to root_path, notice: "No está autorizado para acceder a esta página"
      end
    end

    # Only allow a list of trusted parameters through.
    def offer_params
      params.require(:offer).permit(:title, :description, :active, :limit)
    end
end
