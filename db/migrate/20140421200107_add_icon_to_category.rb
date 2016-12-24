class AddIconToCategory < ActiveRecord::Migration
  def self.up
    add_attachment :categories, :icon
  end

  def self.down
    remove_attachment :categories, :icon
  end
end
