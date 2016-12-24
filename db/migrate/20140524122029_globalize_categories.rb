class GlobalizeCategories < ActiveRecord::Migration
  def up
    Category.create_translation_table! :name => :string, :description => :text
  end
  def down
    Category.drop_translation_table!
  end
end
