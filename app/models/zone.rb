class Zone < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user

  delegate :email, :facebook_uid, to: :user, prefix: true

  has_and_belongs_to_many :moderators, association_foreign_key: 'moderator_id', join_table: 'moderators_zones', class_name: 'User'

  validates :name, presence: true
  validates :polygon, presence: true

  def rb_points
    ActiveSupport::JSON.decode points
  end
end
