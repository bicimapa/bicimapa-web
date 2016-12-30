class Newsletter < ActiveRecord::Base
  validates :email, presence: true, email: true, uniqueness: true 

  default_scope { select('*, exists(select 1 from users u where u.email = newsletters.email)  as has_account') }
end
