class Ride < ActiveRecord::Base
  belongs_to :user

  has_attached_file :picture, :styles => { :medium => "600x337>", :thumb => "64x64!" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  validates :name, presence: true
  validates :start, presence: true
  validates :path, presence: true

  scope :has_picture, -> { where("picture_file_name is not null") }

  def has_picture
    picture.exists?
  end

  default_scope { select('rides.*, ST_Length(path::geography) as length') }

  after_commit :notify_team, on: [:create]

  def notify_team
    AdminMailer.new_ride().deliver_now
  end

end
