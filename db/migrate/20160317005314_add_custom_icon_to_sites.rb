class AddCustomIconToSites < ActiveRecord::Migration
  def up
    add_attachment :sites, :custom_icon
  end

  def down
    remove_attachment :sites, :custom_icon
  end
end
