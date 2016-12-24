object @user
attributes :id, :first_name, :last_name

node :avatar_url do |user|
  avatar_url(user)
end

