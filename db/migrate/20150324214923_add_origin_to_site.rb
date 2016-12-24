class AddOriginToSite < ActiveRecord::Migration
  def up
    add_column :sites, :origin, :string

    Site.update_all origin: 'ORG'
  end

  def down
    remove_column :sites, :origin
  end
end
