class PagesController < ApplicationController
  def index
  end

  def exito
    @usuario = User.find(params[:id])
  end

  protected

  def page_params
    params.require(:page).permit(:id)
  end
end
