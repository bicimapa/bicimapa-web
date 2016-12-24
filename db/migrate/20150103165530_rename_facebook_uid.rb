class RenameFacebookUid < ActiveRecord::Migration
  def change
	  remove_column :users, :provider
	  rename_column :users, :uid, :facebook_uid
  end
end
