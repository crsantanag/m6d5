require "test_helper"
include ActionDispatch::TestProcess

class PostulationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = User.create!(email: "owner@example.com",
      password: "123456",
      name: "Esteban",
      phone: 987654321,
      curriculum: "CV Esteban",
      role: "owner")
    imagen = fixture_file_upload("esteban_picture.jpg", "image/jpeg")
    @owner.image.attach(imagen)

    @user  = User.create!(email: "user@example.com",
      password: "123456",
      name: "Carlos",
      phone: 987654321,
      curriculum: "CV Carlos",
      role: "normal")
    imagen = fixture_file_upload("juan_picture.jpg", "image/jpeg")
    @user.image.attach(imagen)

    @offer = Offer.create!(title: "Desarrollador de software",
      description: "Multifacético",
      active: true,
      limit: Date.tomorrow,
      user: @owner)
  end

  test "should create a postulation" do
    # Iniciar sesión como un usuario
    sign_in @user

    # Realizar la solicitud de creación de postulación
    post offer_postulations_path(offer_id: @offer.id), params: { postulation: { message: "Estoy interesado en el puesto" } }
    puts

    # Verificar redirección o mensaje flash
    assert_redirected_to postulations_path
    assert_equal "POSTULACIÓN REALIZADA", flash[:alert]
  end
end
