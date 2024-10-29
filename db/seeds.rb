# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(
  email: "esteban@miempresa.cl",
  password: "123456",
  name: "Esteban García",
  phone: 987654321,
  role: 1,
  picture: File.open(Rails.root.join("db/seeds/esteban.jpg")))

puts "La cuenta de Esteban (owner) ha sido creada: esteba@miempresa.cl con privilegios para crear usuarios y ofertas de cargos"

Offer.create!(
  title: "Ayudante bodega",
  Description: "Recibir, verificar e ingresar la documentación y la mercadería que debe resguardarse en la bodega. Almacenar y controlar la mercadería que ingresa de acuerdo con el código establecido. Alistar los pedidos de los materiales de las diferentes unidades administrativas.",
  active: true,
  limit: Date.tomorrow,
  user_id: User.last.id)

Offer.create!(
  title: "Ayudante contable",
  Description: "Dependiente de la gerencia de Administración y Finanzas. El cargo de ayudante contable tiene por función colaborar en trasladar la información de las transacciones diarias a los libros contables digitales, libro diario y libro mayor, en ausencia de libros físicos, para el registro diario de las transacciones.",
  active: true,
  limit: Date.tomorrow,
  user_id: User.last.id)

puts "Se han creado 2 ofertas de cargos"

User.create!(
  email: "steve@miempresa.cl",
  password: "123456",
  name: "Steve Austin",
  phone: 987654321,
  role: 0,
  picture: File.open(Rails.root.join("db/seeds/user1.jpg")))

User.create!(
  email: "linda@miempresa.cl",
  password: "123456",
  name: "Linda Hamilton",
  phone: 987654321,
  role: 0,
  picture: File.open(Rails.root.join("db/seeds/user2.jpg")))

User.create!(
  email: "juan@miempresa.cl",
  password: "123456",
  name: "Juan Machuca",
  phone: 987654321,
  role: 0,
  picture: File.open(Rails.root.join("db/seeds/user3.jpg")))

puts "Se crearon las cuentas de Steve, Linda y Juan con el email: nombre@miempresa.cl, paswword: 123456 y sin postulaciones"
