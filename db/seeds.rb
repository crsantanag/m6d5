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
  name: "Esteban ",
  phone: 987654321,
  role: 1,
  picture: File.open(Rails.root.join("db/seeds/esteban.jpg")))
puts "La cuenta de Esteban ha sido creada: esteban@.empresa.cl con privilegios para crear usuarios y ofertas de cargos"
