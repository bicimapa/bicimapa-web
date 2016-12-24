class CreateTableToBeReviewed < ActiveRecord::Migration
  def change
    create_table :to_be_reviewed do |t|

	    t.belongs_to :moderator
	    t.belongs_to :site

	    t.timestamps
    end
  end
end
