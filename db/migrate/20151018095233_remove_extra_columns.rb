class RemoveExtraColumns < ActiveRecord::Migration
  def up
    remove_column :sites, :variety
    remove_column :lines, :variety
    remove_column :lines, :way
    remove_column :zones, :variety
    remove_column :zones, :category_id
    remove_column :zones, :is_active
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
