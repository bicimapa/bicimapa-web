class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.decimal :rate
      t.belongs_to :site
      t.belongs_to :user

      t.timestamps
    end
  end
end
