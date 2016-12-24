class AddPictureToRides < ActiveRecord::Migration
  def up
    add_attachment :rides, :picture
  end

  def down
    remove_attachment :rides, :picture
  end
end
