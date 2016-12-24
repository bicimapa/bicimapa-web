class AddOriginToLine < ActiveRecord::Migration
  def up
    add_column :lines, :origin, :string

    Line.update_all origin: 'ORG'
  end

  def down
    remove_column :lines, :origin
  end
end
