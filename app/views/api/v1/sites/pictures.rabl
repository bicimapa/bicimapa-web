object false

child :pictures do
  node :streetview_lat do
    @site.lonlat.y
  end
  node :streetview_lon do
    @site.lonlat.x
  end
  node :pictures do
    [
      (@site.picture_1.url if @site.picture_1.exists?), 
      (@site.picture_2.url if @site.picture_2.exists?), 
      (@site.picture_3.url if @site.picture_3.exists?)
    ]
  end
end
