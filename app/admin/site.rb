ActiveAdmin.register Site do

  menu parent: "Bicimapa"

  permit_params :name, :description, :lonlat, :category_id, :custom_icon, :is_active, :has_been_reviewed, :picture_1, :picture_2, :picture_3

  scope :all, default: true
  scope :not_reviewed
  scope :has_picture
  scope :has_custom_icon
  scope :has_comments
  
  index do
    selectable_column
    column :id
    column :name
    column :has_been_reviewed
    column :is_active
    column :origin
    column :has_custom_icon do |d| status_tag d.has_custom_icon end
    actions
  end

  show do
    columns do
      column do
        panel "Site details" do
          attributes_table_for site do
            row :id
            row :name
            row :description
            row :latitude
            row :longitude
            row :has_been_reviewed do |site| status_tag site.has_been_reviewed end
            row :is_active do |site| status_tag site.is_active end
            row :category
            row :origin
            row :user
          end
        end
      end

      column do
        panel "Map" do
          div id: "map", style: "width: 100%; height: 470px"
          render partial: 'shared/sites/googlemap', locals: { site: site }
        end
      end
    end

    panel "Comments" do
      table_for site.comments do
        column :user do |comment|
          if comment.user
            link_to comment.user.full_name, admin_user_path(comment.user)
          else
            I18n.t(:anonymous)
          end
        end
        column :comment
      end
    end

    panel "Pictures" do
      img src: site.picture_1.url(:medium) if site.picture_1.exists?
      img src: site.picture_2.url(:medium) if site.picture_2.exists?
      img src: site.picture_3.url(:medium) if site.picture_3.exists?
    end
  end

  form do |f|
    columns do
      column do
        f.inputs 'Details' do
          f.input :name
          f.input :description
          f.input :lonlat, as: :hidden
          f.input :category, :collection => Category.where(variety: "SIT").all, :include_blank => false
          f.input :custom_icon
          f.input :is_active
          f.input :has_been_reviewed
        end
        f.inputs "Pictures" do
          f.input :picture_1
          f.input :picture_2
          f.input :picture_3
        end
      end
      column do
        panel "Map" do
          div id: "map", style: "width: 100%; height: 470px"
          render partial: 'shared/sites/googlemap', locals: { site: site }
        end
      end
    end
    f.actions
  end

  action_item :activate, only: :show, if: proc{ !site.is_active } do
    link_to 'Activate Site', activate_admin_site_path(resource), method: :put
  end

  action_item :deactivate, only: :show, if: proc{ site.is_active } do
    link_to 'Deactivate Site', deactivate_admin_site_path(resource), method: :put
  end

  member_action :activate, method: :put do
    resource.activate!
    redirect_to resource_path, notice: "Site has been activated"
  end

  member_action :deactivate, method: :put do
    resource.deactivate!
    redirect_to resource_path, notice: "Site has been deactivated"
  end

  batch_action :activate do |ids|
    Site.find(ids).each do |site|
      site.activate! 
    end
    redirect_to collection_path, alert: "Sites have been activated."
  end

  batch_action :deactivate do |ids|
    Site.find(ids).each do |site|
      site.deactivate! 
    end
    redirect_to collection_path, alert: "Sites have been deactivated."
  end

  filter :id
  filter :name
  filter :has_been_reviewed
  filter :is_active
  filter :origin, as: :select

end
