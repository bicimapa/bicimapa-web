ActiveAdmin.register Line do

  menu parent: "Bicimapa"

  permit_params :name, :description, :path, :category_id, :is_active
  
  index do
    selectable_column
    column :id
    column :name
    column "Length (km)" do |line| (line.length/1000).round(2) end
    column :is_active
    column :origin
    actions
  end

  show do
    columns do
      column do
        panel "Line Details" do
          attributes_table_for line do
            row :id
            row :name
            row :description
            row "Length (km)" do |line| (line.length/1000).round 2 end
            row :is_active do |line| status_tag line.is_active end
            row :category
            row :origin
            row :user
          end
        end
      end
      column do
        panel "Map" do
          div id: "map", style: "width: 100%; height: 470px"
          render partial: 'shared/lines/googlemap', locals: { line: line }
        end
      end
    end
  end

  form do |f|
    columns do
      column do
        f.inputs 'Details' do
          f.input :name
          f.input :description
          f.input :path, as: :hidden
          f.input :category, :collection => Category.where(variety: "LIN").all, :include_blank => false
          f.input :is_active
        end
      end
      column do
        panel "Map" do
          div id: "map", style: "width: 100%; height: 470px"
	  render partial: 'shared/lines/googlemap', locals: { line: line }
        end
      end
    end
    f.actions
  end

  filter :category
  filter :name
  filter :description
  filter :is_active
  filter :origin

end
