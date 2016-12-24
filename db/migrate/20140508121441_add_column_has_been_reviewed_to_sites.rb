class AddColumnHasBeenReviewedToSites < ActiveRecord::Migration
  def change
    add_column :sites, :has_been_reviewed, :boolean, :default => false
  end
end
