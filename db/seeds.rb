# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: "admin@example.com", password: "password", password_confirmation: "password", last_name: "Admin", first_name: "Bicimapa")

require 'open-uri'

open("https://raw.githubusercontent.com/bicimapa/bicimapa-assets/master/old-pins/parqueadero.png") do |file|
  Category.create(name_en: "Parking", name_fr: "Parking", name_es: "Parqueadero", name_dummy: "■■■■■■■", is_public: true, is_active: true, is_initial: true, variety: 'SIT', icon: file)
end

factory = RGeo::Geographic.spherical_factory(srid: 4326)
Site.create(name: "City parking", category: Category.first, lonlat: factory.point("-74.06099284", "4.68329824"))
