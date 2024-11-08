require "test_helper"
include ActionDispatch::TestProcess

class PostulationsControllerTest < ActionDispatch::IntegrationTest
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

    # Realizo la primera solicitud de creación de postulación
    post offer_postulations_path(offer_id: @offer.id), params: { postulation: { message: "Estoy interesado en el puesto" } }
    puts
    assert_redirected_to postulations_path
    assert_equal "POSTULACIÓN REALIZADA", flash[:alert]

    # Intento crear otra postulación para la misma oferta
    post offer_postulations_path(offer_id: @offer.id), params: { postulation: { message: "Intento duplicado" } }

    # Verifico que el intento duplicado no se permite
    assert_redirected_to offers_path
    assert_equal "NO PUEDE POSTULAR AL MISMO CARGO MÁS DE 1 VEZ", flash[:alert]
  end
end
