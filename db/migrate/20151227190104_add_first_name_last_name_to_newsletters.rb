class AddFirstNameLastNameToNewsletters < ActiveRecord::Migration
  def change
    add_column :newsletters, :last_name, :string
    add_column :newsletters, :first_name, :string
  end
end
