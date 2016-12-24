collection @categories, root: :categories, object_root: false
attributes :id, :name, :variety, :is_public, :is_initial

node(:icon_path, if: lambda { |c| c.variety == 'SIT' }) do |category|
  category.icon.url
end

node(:color, if: lambda { |c| c.variety == 'LIN' }) do |category|
  category.color
end
