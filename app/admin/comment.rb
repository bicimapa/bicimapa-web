ActiveAdmin.register Comment, as: "BicimapaComment" do

  menu parent: "Bicimapa", label: "Comments"

# permit_params :list, :of, :attributes, :on, :model

  index do
    selectable_column
    column :comment
    column :site do |comment| link_to comment.commentable.name, admin_site_path(comment.commentable)  end
    column :user
    column :created_at
    actions
  end

  show do
    panel "Comment Details" do
      attributes_table_for bicimapa_comment do
        row :id
        row :comment
        row :site do |comment| link_to comment.commentable.name, admin_site_path(comment.commentable) end
        row :user
        row :created_at
      end
    end
  end

  form do |f|
    f.inputs 'Details' do
      f.input :comment
    end
    f.actions
  end

end
