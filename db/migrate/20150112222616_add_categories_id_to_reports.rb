class AddCategoriesIdToReports < ActiveRecord::Migration
  def change
    add_column :reports_reports, :reports_category_id, :integer
    add_index :reports_reports, :reports_category_id
    add_column :reports_reports, :reports_sub_category_id, :integer
    add_index :reports_reports, :reports_sub_category_id
  end
end
