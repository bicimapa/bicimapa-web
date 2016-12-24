class AddModeratorToZone < ActiveRecord::Migration
  def change
    add_column :zones, :moderator_id, :integer
  end
end
