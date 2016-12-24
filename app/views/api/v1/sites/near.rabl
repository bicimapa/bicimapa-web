collection @sites, root: :sites, object_root: false
attributes :id, :name, :latitude, :longitude

node :distance do |site|
  lat, lng = params[:ll].split(',')
  a = Geokit::LatLng.new(lat, lng)
  b = Geokit::LatLng.new(site.latitude, site.longitude)
  (a.distance_to(b, { unit: :kms })*1000).round
end

node :created_at do |site|
  site.created_at.to_i
end

node :updated_at do |site|
  site.updated_at.to_i
end

node(:deleted_at, unless: lambda { |s| s.deleted_at == nil }) do |site|
  site.deleted_at.to_i
end
