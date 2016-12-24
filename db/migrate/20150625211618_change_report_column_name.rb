class ChangeReportColumnName < ActiveRecord::Migration
  def change
    rename_column :reports_reports, :reports_category_id, :category_id
    rename_column :reports_reports, :reports_sub_category_id, :sub_category_id
  end
end
