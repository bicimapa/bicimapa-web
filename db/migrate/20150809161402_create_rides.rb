class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :name, null: false
      t.text :description
      t.datetime :start, null: false
      t.datetime :end
      t.line_string :path, srid: 4326, null: false
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
