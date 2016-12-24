class CreateReportsStatuses < ActiveRecord::Migration
  def change
    create_table :reports_statuses do |t|
      t.string :code
      t.string :label
      t.string :description

      t.timestamps null: false
    end
  end
end
