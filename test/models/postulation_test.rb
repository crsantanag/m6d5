require "test_helper"
include ActionDispatch::TestProcess

class PostulationTest < ActiveSupport::TestCase
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

    # Crear la postulación para el usuario
    postulation = Postulation.new(user: @user, offer: @offer, message: "Estoy interesado en el puesto")
    puts

    assert postulation.save, "La postulación debería guardarse correctamente"

    # Verificar que la postulación se asocie correctamente con el usuario y la oferta
    assert_equal @user,  postulation.user
    assert_equal @offer, postulation.offer
  end
end
