require "test_helper"
include ActionDispatch::TestProcess

class PostulationTest < ActiveSupport::TestCase
  def setup
    @owner = users(:owner)        # Carga el owner desde los fixtures
    @user  = users(:juan)         # Carga el usuario desde los fixtures
    sign_in @user                 # Hace sign_in del usuario cargado
    @offer = offers(:first_offer) # Carga una oferta desde los fixtures

    # Limpio las postulaciones previas para asegurar un estado limpio
    Postulation.where(user: @user, offer: @offer).destroy_all
  end

  test "should create a postulation" do
    # Asigno imagenes de prueba
    @owner.image.attach(fixture_file_upload("esteban_picture.jpg", "image/jpeg")) # No es necesario, pero igual lo ahacemos
    @user.image.attach(fixture_file_upload("juan_picture.jpg", "image/jpeg"))     # El user necesita una imagen para poder postular

    # Crear la postulación para el usuario
    postulation = Postulation.new(user: @user, offer: @offer, message: "Estoy interesado en el puesto")
    puts

    assert postulation.save, "La postulación debería guardarse correctamente"

    # Verificar que la postulación se asocie correctamente con el usuario y la oferta
    assert_equal @user,  postulation.user
    assert_equal @offer, postulation.offer
  end
end
