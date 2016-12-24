class Rating < ActiveRecord::Base
  belongs_to :site
  belongs_to :user

  validates :rate, :presence => true
end
