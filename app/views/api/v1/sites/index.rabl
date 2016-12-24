collection @sites, root: :sites, object_root: false
attributes :id, :name, :description, :latitude, :longitude, :category_id, :is_active, :has_been_reviewed

node :category_icon_url do |site|
  site.category.icon.url
end

node(:deleted_at) do |site|
  site.deleted_at.to_i
end
