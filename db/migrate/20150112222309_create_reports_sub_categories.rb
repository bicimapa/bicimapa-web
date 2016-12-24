class CreateReportsSubCategories < ActiveRecord::Migration
  def change
    create_table :reports_sub_categories do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
