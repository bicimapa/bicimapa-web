class AddFinalStateToStatuses < ActiveRecord::Migration
  def change
    add_column :reports_statuses, :is_final_state, :boolean, default: false
  end
end
