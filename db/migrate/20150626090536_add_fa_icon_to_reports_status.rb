class AddFaIconToReportsStatus < ActiveRecord::Migration
  def change
    add_column :reports_statuses, :fa_icon, :string
  end
end
