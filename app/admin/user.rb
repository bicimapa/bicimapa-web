ActiveAdmin.register User do

  menu parent: "Users", label: "Accounts"
  actions :all, :except => :new
  
  permit_params :last_name, :first_name, :email, :is_moderator, :is_admin, zone_ids: []

  scope :facebook

  index do
    selectable_column
    column :id
    column :last_name
    column :first_name
    column :email
    column :is_admin
    column :is_moderator
    column :receive_notifications
    column :has_facebook do |user| status_tag user.has_facebook end
    actions
  end

  show do
    panel "User details" do
      attributes_table_for user do
        row :id
        row :first_name
        row :last_name
        row :email
        row :is_admin do |user| status_tag user.is_admin end
        row :is_moderator do |user| status_tag user.is_moderator end
        row :receive_notifications do |user| status_tag user.receive_notifications end
        row :facebook_uid
        row :token
        row :locale
      end
    end
    if user.is_moderator
      panel "Moderator zones" do
        table_for user.zones do
          column :name do |zone| link_to zone.name, admin_zone_path(zone) end
        end
      end
    end
  end

  sidebar "Avatar", only: :show do
    img src: avatar_url(user)
  end

  filter :last_name
  filter :first_name
  filter :email
  filter :is_admin
  filter :is_moderator
  filter :receive_notifications

  form do |f|
    inputs "Details" do
      input :last_name
      input :first_name
      input :email
      input :is_admin
      input :is_moderator
    end
    inputs "Moderator zones" do
      input :zones
    end
    actions
  end

end
