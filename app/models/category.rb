class Category < ActiveRecord::Base
  acts_as_paranoid

  has_attached_file :icon, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :icon, content_type: ['image/jpg', 'image/jpeg', 'image/png']

  has_many :sites
  has_many :lines
  has_many :zones

  translates :name, :description
  globalize_accessors

  paginates_per 5
end
