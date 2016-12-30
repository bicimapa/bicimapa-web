collection @sites, root: :sites, object_root: false
attributes :id, :name, :description, :latitude, :longitude, :category_id

node :icon_url do |site|
  site.icon.url
end
