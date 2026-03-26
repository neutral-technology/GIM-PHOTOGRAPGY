# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# BrochurePreset.find_or_create_by!(name: 'Anniversaire') do |p|
#   p.description = "Brochure d'anniversaire"
# end

Rails.logger.debug '--- Seeding New Presets ---'

# 1. Traditional Dote
BrochurePreset.find_or_create_by!(name: 'Dote') do |p|
  p.description = 'Brochure de fête traditionnelle'
end

# 2. Advanced Wedding (The one we just built)
BrochurePreset.find_or_create_by!(name: 'wedding_advanced') do |p|
  p.description = 'Mise en page élégante et moderne (12 pages)'
end

BrochurePreset.find_or_create_by!(name: 'wedding_pro') do |p|
  p.description = 'Mise en page élégante et moderne (24 pages)'
end
# 3. Generic Default
BrochurePreset.find_or_create_by!(name: 'Default') do |p|
  p.description = 'Brochure générique'
end

Rails.logger.debug { "✅ Records created. Total Presets: #{BrochurePreset.count}" }

require 'securerandom'

puts "🌱 Seeding users..."

User.find_or_create_by!(email: "info@gimservice.com") do |user|
  user.password = "gimservice2026"
  user.password_confirmation = "gimservice2026"
  user.full_name = "Gim Service"
  user.city = "Lubumbashi"
  user.sex = "M",
  user.tel = "097#{rand(1000000..9999999)}"
  user.unique_id = SecureRandom.hex(5)
  user.vip_threshold = rand(1..10)
  user.role = :photographer
end

User.find_or_create_by!(email: "joskalenda3@gmail.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.full_name = "Jos Topaz"
  user.city = "Captown"
  user.sex = "M",
  user.tel = "0780468223"
  user.unique_id = SecureRandom.hex(5)
  user.vip_threshold = rand(1..10)
  user.role = :super_admin
end

puts "✅ Users seeded!"


puts "🌱 Seeding album..."

photographer = User.find_by(email: "info@gimservice.com")

# Create a client first (required)
client = photographer.clients.find_or_create_by!(full_name: "Default Client") do |c|
  c.full_name = "Default Client"
  c.tel = "099#{rand(1000000..9999999)}"
end

# Create the album
Album.find_or_create_by!(name: "GIM", user: photographer) do |album|
  album.client = client
  album.public = true
  album.slug = "gim-#{SecureRandom.hex(3)}"
end

puts "✅ Album created!"