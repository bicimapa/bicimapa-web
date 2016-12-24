class Announcement < ActiveRecord::Base
  validates :body, presence: true

  def self.current
    result = where('starts_at <= :now and ends_at >= :now', now: Time.zone.now)
    result.last
  end

  def self.newest
    Announcement.last
  end

  def self.newest_private
    Announcement.where('type is null').order('id desc').first
  end

  def self.newest_public
    Announcement.where("type = 'public'").order('id desc').first
  end
end
