class AddUserToLine < ActiveRecord::Migration
  def change
	  change_table :lines do |t|
		  t.belongs_to :user
	  end
  end
end
