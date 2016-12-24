class AddOriginAndUserToReport < ActiveRecord::Migration
  def change
    add_column :reports_reports, :user_id, :integer
    add_column :reports_reports, :origin, :string
  end
end
