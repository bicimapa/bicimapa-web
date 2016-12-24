class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :name
      t.text :description
      t.text :points
      t.boolean :is_active
      t.datetime :deleted_at
      t.string :way, :limit => 3, :default => 'RIG' # LEF for LEFT (<--), RIG for RIGHT (-->), DUA for DUAL (<->)
      t.string :variety, :limit => 3, :default => 'DEF' # DEF for DEFAULT
      t.belongs_to :category

      t.timestamps
    end
  end
end
