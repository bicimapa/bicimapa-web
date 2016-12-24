class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.text :description
      t.decimal :latitud
      t.decimal :longitud
      t.boolean :is_active
      t.datetime :deleted_at
      t.string :variety, :limit => 3, :default => 'DEF' # DEF for DEFAULT, PAR for PARKING
      t.belongs_to :category

      t.timestamps
    end
  end
end
