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

puts "--- Seeding New Presets ---"

# 1. Traditional Dote
BrochurePreset.find_or_create_by!(name: 'Dote') do |p|
  p.description = 'Brochure de fête traditionnelle'
end

# 2. Advanced Wedding (The one we just built)
BrochurePreset.find_or_create_by!(name: 'wedding_advanced') do |p|
  p.description = 'Mise en page élégante et moderne (12 pages)'
end

# 3. Generic Default
BrochurePreset.find_or_create_by!(name: 'Default') do |p|
  p.description = 'Brochure générique'
end

puts "✅ Records created. Total Presets: #{BrochurePreset.count}"