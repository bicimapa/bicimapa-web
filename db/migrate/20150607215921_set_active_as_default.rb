class SetActiveAsDefault < ActiveRecord::Migration
  def up
    change_column_default :sites, :is_active, true
    Site.where(:has_been_reviewed => false).update_all(:is_active => true)
  end
  def down
    change_column_default :sites, :is_active, false
    Site.where(:has_been_reviewed => false).update_all(:is_active => false)
  end
end
