class AddIndexes < ActiveRecord::Migration
  def change
	add_index :lines, :category_id
	add_index :lines, :user_id
	add_index :moderators_zones, :zone_id
	add_index :ratings, :site_id
	add_index :ratings, :user_id
	add_index :sites, :category_id
	add_index :sites, :user_id
	add_index :to_be_reviewed, :site_id
	add_index :zones, :category_id
	add_index :zones, :user_id
  end
end
