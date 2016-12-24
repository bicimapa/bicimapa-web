class Reports::Report < ActiveRecord::Base
  has_one :category, class_name: '::Reports::Category', primary_key: 'category_id', foreign_key: 'id'
  has_one :sub_category, class_name: '::Reports::SubCategory', primary_key: 'sub_category_id', foreign_key: 'id'
  belongs_to :user
  has_many :states, -> { order 'created_at desc' }, { class_name: '::Reports::State', primary_key: 'id', foreign_key: 'report_id' }

  has_attached_file :photo, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  paginates_per 5

  def icon_url
    ActionController::Base.helpers.asset_path("warn_pin.png")
  end

  after_commit :notify_twitter, on: [:create]

  def notify_twitter
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    require 'open-uri'

    static_map_url = "https://maps.googleapis.com/maps/api/staticmap?size=500x400&markers=icon:http://goo.gl/YOvnh9%7C#{latitude},#{longitude}&key=#{ENV['GOOGLE_MAP_API_KEY']}"
    static_map = open(static_map_url).to_io

    picture = nil
    picture = File.open(photo.path) if photo.exists?

    media_ids = [picture, static_map].compact.map do |file| 
      client.upload file
    end

    prefix = "#bicimappers #{Rails.application.routes.url_helpers.report_url(id: self.id)} cc @IDRD @idubogota @mejorenbici" 

    max_length = 140 - (prefix.length + 1 + 24)

    #tweet limit 140 (pictures count for 24)
    abstract = description[0..max_length-1] 
    abstract = abstract[0..-4] + "..." if description.length > max_length

    tweet = "#{abstract} #{prefix}"
    
    client.update(tweet, media_ids: media_ids.join(','), lat: latitude, lon: longitude, display_coordinates: true)
  end
end
