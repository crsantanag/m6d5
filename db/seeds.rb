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
  email: "esteban@empresa.cl",
  password: "123456",
  name: "Esteban Steele",
  phone: 987654321,
  role: 1,
  picture: File.open(Rails.root.join("db/seeds/esteban.jpg")))
puts "La cuenta de Esteban (owner) ha sido creada: esteban@empresa.cl con privilegios para crear usuarios y ofertas de cargos"

User.create!(
  email: "steve@empresa.cl",
  password: "123456",
  name: "Steve Austin",
  phone: 987654321,
  role: 0,
  picture: File.open(Rails.root.join("db/seeds/user1.jpg")))
puts "La cuenta de Steve (empleado) ha sido creada: steve@empresa.cl con 2 postulaciones "

User.create!(
  email: "linda@empresa.cl",
  password: "123456",
  name: "Linda Hamilton",
  phone: 987654321,
  role: 0,
  picture: File.open(Rails.root.join("db/seeds/user2.jpg")))
puts "La cuenta de Linda (emplaeda) ha sido creada: linda@empresa.cl con 1 postulación"

User.create!(
  email: "juan@empresa.cl",
  password: "123456",
  name: "Juan Machuca",
  phone: 987654321,
  role: 0,
  picture: File.open(Rails.root.join("db/seeds/user3.jpg")))
puts "La cuenta de Juan (empleado)ha sido creada: juan@empresa.cl sin postulaciones"
