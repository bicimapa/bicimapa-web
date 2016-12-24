class ChangeReportDescriptionToText < ActiveRecord::Migration
  def change
    change_column :reports_reports, :description, :text
  end
end
