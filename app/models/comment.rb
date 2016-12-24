class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment

  belongs_to :commentable, polymorphic: true

  default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  # acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  validates :comment, presence: true

  after_commit :notify_team, on: [:create]
  after_commit :notify_owner, on: [:create]
  after_commit :notify_commenters, on: [:create]

  def notify_owner
    site = Site.find self.commentable_id
    DefaultMailer.notify_site_owner_new_comment(user, site).deliver if site.user && site.user.receive_notifications && (site.user != self.user)
  end

  def notify_commenters
    site = Site.find self.commentable_id
    site.comments.map { |c| c.user }.compact.uniq.reject { |u| u == self.user || u == site.user }.each do |user|
      DefaultMailer.notify_site_new_comment(user, site).deliver if user.receive_notifications
    end
  end

  def notify_team
    users = ApplicationController.helpers.get_team_users
    users.each do |user|
      DefaultMailer.notify_team_new_comment(user).deliver
    end
  end

end
