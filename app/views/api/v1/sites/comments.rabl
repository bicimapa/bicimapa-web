collection @comments, root: :comments, object_root: false
attributes :comment, :created_at

node :added_by do |comment|
  full_name(comment.user)
end

node :avatar_url do |comment|
  avatar_url(comment.user, 50) if comment.user
end
