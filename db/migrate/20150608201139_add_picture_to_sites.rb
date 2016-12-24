class AddPictureToSites < ActiveRecord::Migration
  def up
    add_attachment :sites, :picture_1
    add_attachment :sites, :picture_2
    add_attachment :sites, :picture_3
  end
  def down
    remove_attachment :sites, :picture_1
    remove_attachment :sites, :picture_2
    remove_attachment :sites, :picture_3
  end
end
