class Newsletter < ActiveRecord::Base
  validates :email, presence: true, email: true, uniqueness: true 
end
