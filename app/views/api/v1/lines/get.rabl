collection @lines, root: :lines, object_root: false
attributes :id, :path

node :color do |line|
  line.category.color
end
