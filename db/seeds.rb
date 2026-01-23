# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
BrochurePreset.find_or_create_by!(name: "Anniversaire") do |p|
  p.description = "Brochure d'anniversaire"
end

BrochurePreset.find_or_create_by!(name: "Dot") do |p|
  p.description = "Brochure de fête traditionelle"
end

BrochurePreset.find_or_create_by!(name: "Valentine") do |p|
  p.description = "Brochure de saint valentin"
end

BrochurePreset.find_or_create_by!(name: "Default") do |p|
  p.description = " Brochure generique"
end
