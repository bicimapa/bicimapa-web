class Line < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :category
  belongs_to :user

  validates :name, presence: true
  validates :path, presence: true
  validates :category, presence: true
  validates :is_active, presence: true

  delegate :name, :color, to: :category, prefix: true
  delegate :email, :facebook_uid, to: :user, prefix: true

  default_scope { select('lines.*, ST_Length(path::geography) as length') }
end
