class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :facebook, -> { where.not(facebook_uid: nil) }

  has_many :comments

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "64x64!" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  devise :omniauthable, omniauth_providers: [:facebook]

  validates :email, presence: true
  validates :last_name, presence: true
  validates :first_name, presence: true

  def self.find_for_facebook_oauth(auth)
    user = where(facebook_uid: auth.uid).first
    return user unless user == nil

    user = where(email: auth.info.email).first

    if user != nil
      user.facebook_uid = auth.uid
    else
      user = User.create do |user|
        user.facebook_uid = auth.uid
        user.email = auth.info.email
        user.last_name = auth.info.last_name
        user.first_name = auth.info.first_name
        user.password = Devise.friendly_token[0, 20]
      end
    end

    return user
  end

  def self.find_for_facebook_ios(facebook_id)
    app = FbGraph::Application.new(ENV['FACEBOOK_APP_ID'], secret: ENV['FACEBOOK_SECRET_ID'])
    facebook_user = FbGraph::User.fetch(facebook_id, access_token: app.get_access_token)
    
    user = where(facebook_uid: facebook_id).first
    return user unless user == nil

    user = where(email: facebook_user.email).first

    if user != nil
      user.facebook_uid = facebook_id
    else
      user = User.create do |user|
        user.facebook_uid = facebook_id
        user.email = facebook_user.email
        user.last_name = facebook_user.last_name
        user.first_name = facebook_user.first_name
        user.password = Devise.friendly_token[0, 20]
      end
    end

    return user
  end

  before_save :create_token
  before_save :set_first_user_admin
  before_save :subscribe_newsletter

  def subscribe_newsletter
    newsletter = Newsletter.where(:email => self.email).first_or_initialize.update_attributes!(email: self.email, last_name: self.last_name, first_name: self.first_name)
  end

  def set_first_user_admin
    self.is_admin = true if (User.unscoped.count == 0)
  end

  def create_token
    self.token = generate_token if token.blank?
  end

  def generate_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(token: token).first
    end
  end

  has_many :sites
  has_many :lines

  has_and_belongs_to_many :zones, class_name: 'Zone', join_table: 'moderators_zones', foreign_key: 'moderator_id'
  has_many :ratings

  def full_name
    "#{last_name} #{first_name}"
  end

  def has_facebook
    facebook_uid != nil
  end
end
