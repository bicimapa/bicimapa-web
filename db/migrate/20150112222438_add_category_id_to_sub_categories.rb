class AddCategoryIdToSubCategories < ActiveRecord::Migration
  def change
    add_column :reports_sub_categories, :reports_category_id, :integer
    add_index :reports_sub_categories, :reports_category_id
  end
end
