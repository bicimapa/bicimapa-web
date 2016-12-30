ActiveAdmin.register Zone do

  menu parent: "Bicimapa"

  permit_params :name, :description, :polygon
  
  index do
    selectable_column
    column :name
    actions
  end

  show do
    columns do
      column do
        panel "Zone Details" do
          attributes_table_for zone do
            row :id
            row :name
            row :description
            row :created_at
          end
        end
      end
      column do
        panel "Map" do
          div id: "map", style: "width: 100%; height: 470px"
          render partial: 'shared/zones/googlemap', locals: { zone: zone }
        end
      end
    end
    panel "Moderators" do
      table_for zone.moderators do
        column :name do |moderator| link_to moderator.full_name, admin_user_path(moderator) end
      end
    end
  end

  form do |f|
    columns do
      column do
        f.inputs 'Details' do
          f.input :name
          f.input :description
          f.input :polygon, as: :hidden
        end
      end
      column do
        panel "Map" do
          div id: "map", style: "width: 100%; height: 470px"
	  render partial: 'shared/zones/googlemap', locals: { zone: zone }
        end
      end
    end
    f.actions
  end

  filter :name
  filter :moderators, as: :select, collection: User.where(is_admin: true)

end
