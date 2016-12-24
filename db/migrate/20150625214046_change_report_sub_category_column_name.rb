class ChangeReportSubCategoryColumnName < ActiveRecord::Migration
  def change
    rename_column :reports_sub_categories, :reports_category_id, :category_id
  end
end
