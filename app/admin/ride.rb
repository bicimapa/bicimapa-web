ActiveAdmin.register Ride do

  menu parent: "Bicimapa"

  permit_params :name, :description, :start, :end, :picture, :path

  scope :all
  scope :has_picture

  index do
    selectable_column
    column :id
    column :name
    column :description
    column "Length (km)" do |ride| (ride.length/1000).round(2) end
    column :start
    column :end
    column :has_picture do |ride| status_tag ride.has_picture end
    actions
  end

  show do
    columns do
      column do
        panel "Ride Details" do
          attributes_table_for ride do
            row :id
            row :name
            row :description
            row "Length (km)" do |ride| (ride.length/1000).round 2 end
            row :has_picture do |ride| status_tag ride.has_picture end
            row :start
	    row :end
	    row :user
          end
        end
      end
      column do
        panel "Map" do
          div id: "map", style: "width: 100%; height: 470px"
          render partial: 'shared/rides/googlemap', locals: { ride: ride }
        end
      end
    end
    panel "Pictures" do
      img src: ride.picture.url(:medium) if ride.picture.exists?
    end
  end

  form do |f|
    columns do
      column do
        f.inputs 'Details' do
          f.input :name
          f.input :description
	  f.input :start
	  f.input :end
	  f.input :picture
          f.input :path, as: :hidden
        end
      end
      column do
        panel "Map" do
          div id: "map", style: "width: 100%; height: 470px"
	  render partial: 'shared/rides/googlemap', locals: { ride: ride }
        end
      end
    end
    f.actions
  end


  filter :name
  filter :description
  filter :start
  filter :end

end
