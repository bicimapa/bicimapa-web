ActiveAdmin.register Category do

  menu parent: "Bicimapa"

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  index do
    selectable_column
    column :name
    column :is_active
    column :is_public
    column :is_initial
    column :variety
    actions
  end

  show do
    panel "Category details" do
      attributes_table_for category do
        row :name
        row :description
        row :is_public do |category| status_tag category.is_public end
        row :is_active do |category| status_tag category.is_active end
        row :is_initial do |category| status_tag category.is_initial end
        row :variety
      end
    end
  end

  sidebar "Icon/Color", only: :show do
    img src: category.icon.url if category.variety == "SIT"
    div style: "width: 55px; height: 55px; background-color: #{category.color}" if category.variety != "SIT"
  end

  filter :name
  filter :is_active
  filter :is_public
  filter :is_initial
  filter :variety, as: :select

end
