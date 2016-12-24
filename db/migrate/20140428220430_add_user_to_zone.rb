class AddUserToZone < ActiveRecord::Migration
  def change
	  change_table :zones do |t|
		  t.belongs_to :user
	  end
  end
end
