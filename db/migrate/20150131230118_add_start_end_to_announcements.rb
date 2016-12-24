class AddStartEndToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :starts_at, :datetime
    add_column :announcements, :ends_at, :datetime
  end
end
