object false

child :stats do
  node :comments_count do
    @site.comments.count
  end

  node :pictures_count do
    
    i = 0

    i = i + 1 if @site.picture_1.exists?
    i = i + 1 if @site.picture_2.exists?
    i = i + 1 if @site.picture_3.exists?

    i
  end
end
