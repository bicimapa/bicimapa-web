class Line < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :category
  belongs_to :user

  delegate :name, :color, to: :category, prefix: true
  delegate :email, :facebook_uid, to: :user, prefix: true
end
