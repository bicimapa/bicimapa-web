class Site < ActiveRecord::Base

  after_update :notify_update
  
  scope :not_reviewed, -> { where(has_been_reviewed: false) }
  scope :has_custom_icon, -> { where("custom_icon_file_name is not null") }
  scope :has_picture, -> { where("picture_1_file_name is not null or picture_2_file_name is not null or picture_3_file_name is not null") }
  scope :has_comments, -> { joins(:comments).distinct }

  def activate!
    update(has_been_reviewed: true, is_active: true)
  end

  def deactivate!
    update(has_been_reviewed: true, is_active: false)
  end

  acts_as_commentable
  acts_as_paranoid
  acts_as_mappable default_units: :kms,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  belongs_to :category

  belongs_to :user

  delegate :email, :facebook_uid, to: :user, prefix: true, allow_nil: true
  delegate :name, to: :category, prefix: true

  validates :name, presence: true
  validates :category, presence: true
  validates :lonlat, presence: true

  paginates_per 20 # 2cols*10lines

  has_attached_file :picture_1, :styles => { :medium => "660x337>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture_1, :content_type => /\Aimage\/.*\Z/

  has_attached_file :picture_2, :styles => { :medium => "660x337>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture_2, :content_type => /\Aimage\/.*\Z/

  has_attached_file :picture_3, :styles => { :medium => "660x337>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture_3, :content_type => /\Aimage\/.*\Z/

  has_attached_file :custom_icon, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :custom_icon, :content_type => /\Aimage\/.*\Z/

  def latitude=(value)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    self.lonlat = factory.point(longitude, value)
  end

  def latitude
    lonlat.try(:y)
  end

  def longitude=(value)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    self.lonlat = factory.point(value, latitude)
  end

  def longitude
    lonlat.try(:x)
  end

  def has_custom_icon
    custom_icon.exists?
  end

  def has_picture
    picture_1.exists? || picture_2.exists? || picture_3.exists?
  end

  def has_comments
    comments.count > 0
  end

  def icon_url
    if custom_icon.exists?
      custom_icon.url
    else
      category.icon.url 
    end
  end

  def nearest_sites
    Site.within(0.300, origin: self).where('sites.is_active' => true).reject { |e| e == self }
  end

  def nb_rating
    Rating.where(['site_id = ?',  id]).count
  end

  def rating
    Rating.where(['site_id = ?',  id]).average(:rate)
  end

  def user_rating(user_id)
    Rating.where(['site_id = ? and user_id = ?', id, user_id]).first_or_initialize.rate
  end

  protected

  def notify_update
    if lonlat_changed? || name_changed? || description_changed? || category_id_changed? then
      if user
        DefaultMailer.notify_site_update_creator(user, self).deliver if user.receive_notifications
      end

      comments.map { |c| c.user }.compact.uniq.each do |user|
        DefaultMailer.notify_site_update_commenter(user, self).deliver if user.receive_notifications
      end
    end
  end

end
