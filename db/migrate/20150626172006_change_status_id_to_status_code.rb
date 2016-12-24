class ChangeStatusIdToStatusCode < ActiveRecord::Migration
  def change
    rename_column :reports_states, :status_id, :status_code
  end
end
