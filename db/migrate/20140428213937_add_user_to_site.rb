class AddUserToSite < ActiveRecord::Migration
  def change
	 change_table :sites do |t|
		 t.belongs_to :user
	 end
  end
end
