class AddIsInitialToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :is_initial, :boolean, default: false
  end
end
