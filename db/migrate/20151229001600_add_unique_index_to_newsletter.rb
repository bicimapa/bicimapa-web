class AddUniqueIndexToNewsletter < ActiveRecord::Migration
  def change
    add_index :newsletters, :email, unique: true
  end
end
