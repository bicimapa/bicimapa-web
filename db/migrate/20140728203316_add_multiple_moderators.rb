class AddMultipleModerators < ActiveRecord::Migration
  def up

	remove_column :zones, :moderator_id

	create_table :moderators_zones do |t|

		t.integer :moderator_id
		t.integer :zone_id
	end

  end

  def down

	add_column :zones, :moderator_id, :integer

	drop_table :moderators_zones

  end
end
