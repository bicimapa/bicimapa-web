class Ride < ActiveRecord::Base
  belongs_to :user

  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "64x64!" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  validates :name, presence: true
  validates :start, presence: true
  validates :path, presence: true


  after_commit :notify_team, on: [:create]

  def notify_team
    users = ApplicationController.helpers.get_team_users
    users.each do |user|
      DefaultMailer.notify_team_new_ride(user, self).deliver
    end
  end

end
