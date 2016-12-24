class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.boolean :is_public
      t.boolean :is_active
      t.datetime :deleted_at
      t.string :variety, :limit => 3 # LIN for LINE, SIT for SITE
      t.string :color, :limit => 7 # hex value

      t.timestamps
    end
  end
end
