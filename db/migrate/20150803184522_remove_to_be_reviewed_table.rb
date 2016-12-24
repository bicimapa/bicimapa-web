class RemoveToBeReviewedTable < ActiveRecord::Migration
  def up
    drop_table :to_be_reviewed
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
