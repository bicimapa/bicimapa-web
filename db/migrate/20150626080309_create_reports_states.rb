class CreateReportsStates < ActiveRecord::Migration
  def change
    create_table :reports_states do |t|
      t.string :comment
      t.integer :status_id
      t.integer :report_id

      t.timestamps
    end
  end
end
