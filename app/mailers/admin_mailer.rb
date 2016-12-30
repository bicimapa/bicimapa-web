class AdminMailer < ActionMailer::Base
  default to: Proc.new { User.where(is_admin: true).pluck(:email) },
          from: 'no-reply@bicimapa.com'

  def new_comment
    mail(subject: I18n.t(:notify_new_comment_subject))
  end

  def new_ride
    mail(subject: I18n.t(:notify_new_ride_subject))
  end
end
