# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  before_action :configure_sign_in_params, only: [ :create ]
  respond_to :html, :json

  def create
    if request.format.json?
      email = params[:email] || params.dig(:session, :email)
      password = params[:password] || params.dig(:session, :password)

      user = User.find_by(email: email)

      if user&.valid_password?(password)
        sign_in(:user, user)
        render json: { message: "Login exitoso", user_id: user.id, auth_token: user.authentication_token }, status: :ok
      else
        render json: { error: "Credenciales inválidas" }, status: :unauthorized
      end
    else
      super
    end
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :email, :password ])
  end
end
