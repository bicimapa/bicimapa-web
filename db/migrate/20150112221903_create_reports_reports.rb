class CreateReportsReports < ActiveRecord::Migration
  def change
    create_table :reports_reports do |t|
      t.string :description
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
