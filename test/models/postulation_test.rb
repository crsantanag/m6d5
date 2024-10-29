require "test_helper"

class PostulationTest < ActiveSupport::TestCase
  setup do
    @admin = User.create!(email: "owner@example.com",  password: "123456", role: "owner",  phone: 987654321, name: "Esteban", curriculum: "CV Esteban")
    @user  = User.create!(email: "carlos@example.com", password: "123456", role: "normal", phone: 987654321, name: "Carlos", curriculum: "CV Carlos")
    @offer = Offer.create!(title: "Desarrollador de software", description: "Multifacético", active: true, limit: Date.tomorrow, user: @admin)
  end

  test "should create a postulation" do
    # Crear la postulación para el usuario
    postulation = Postulation.new(user: @user, offer: @offer, message: "Estoy interesado en el puesto.")
    assert postulation.save, "La postulación debería guardarse correctamente"

    # Verificar que la postulación se asocie correctamente con el usuario y la oferta
    assert_equal @user, postulation.user
    assert_equal @offer, postulation.offer
  end
end
