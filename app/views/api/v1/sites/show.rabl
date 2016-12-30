object @site
attributes :id, :name, :description, :category_id, :latitude, :longitude, :nb_rating, :rating

node :category_icon_url do |site|
  site.category.icon.url
end

node :custom_icon_url do |site|
  site.custom_icon.url if site.custom_icon.exists?
end

node :comments_count do |site|
  site.comments.count
end

node :pictures_count do |site|
  
  i = 0

  i = i + 1 if site.picture_1.exists?
  i = i + 1 if site.picture_2.exists?
  i = i + 1 if site.picture_3.exists?

  i
end

node :added_by do |site|
  added_by_without_html(site)
end
