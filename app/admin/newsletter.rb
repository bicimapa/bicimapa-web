ActiveAdmin.register Newsletter do

  menu parent: "Users"
    
  permit_params :email, :last_name, :first_name

  index do
    selectable_column
    column :email
    column :last_name
    column :first_name
    column :has_account do |newsletter| status_tag newsletter.has_account  end
    actions
  end

  show do
    panel "Newsletter Details" do
      attributes_table_for newsletter do
        row :id
        row :email
        row :created_at
        row :last_name
        row :first_name
        row :has_account do |newsletter| status_tag newsletter.has_account  end
      end
    end
  end

end
