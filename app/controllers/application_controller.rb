class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_user_postulations, if: :user_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authorize_request(kind = nil)
    unless kind.include?(current_user.role)
      redirect_to offers_path, notice: "No está autorizado para realizar esta acción"
    end
  end

  protected

  def set_user_postulations
    @postulations = Postulation.where(user_id: current_user.id).order(created_at: :desc)
    @postulations_unseen = Postulation.where(saw: false)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :phone, :role, :curriculum, :image ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :phone, :role, :curriculum, :image ])
  end

  def after_sign_in_path_for(resource)
    if current_user.normal?
      if !current_user.curriculum.present? || !current_user.image.present?
        flash[:alert] = "PARA PODER POSTULAR DEBE INGRESAR CURRÍCULO Y FOTO EN SU PERFIL"
        return edit_user_registration_path
      end
    end
    root_path
  end
end
