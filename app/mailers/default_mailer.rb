class DefaultMailer < ActionMailer::Base
  default from: 'no-reply@bicimapa.com'


  def notify_pending_review(user, zone, nb)
    @zone_name = zone.name
    @sites_count = nb
    @user = user
    @sites = Site.find_by_sql(['select distinct s.* from sites s cross join (select polygon from moderators_zones mz join zones z on z.id = mz.zone_id where mz.moderator_id = ?) t where ST_Within(s.lonlat::geometry, t.polygon) = true and s.has_been_reviewed = false and s.deleted_at is null order by created_at desc', user.id])

    I18n.with_locale(user.locale) do
      mail(
        to: user.email,
        subject: I18n.t(:mail_subject, zone_name: zone.name, sites_count: nb)
      )
    end
  end

  def notify_site_update_creator(user, site)
    @site = site

    I18n.with_locale(user.locale) do
      mail(
        to: user.email,
        subject: I18n.t(:notify_site_update_creator_mail_subject)
      )
    end
  end

  def notify_site_update_commenter(user, site)
    @site = site

    I18n.with_locale(user.locale) do
      mail(
        to: user.email,
        subject: I18n.t(:notify_site_update_commenter_mail_subject)
      )
    end
  end

  def notify_site_new_comment(user, site)
    @site = site

    I18n.with_locale(user.locale) do
      mail(
        to: user.email,
        subject: I18n.t(:notify_site_new_comment_mail_subject)
      )
    end
  end

  def notify_site_owner_new_comment(user, site)
    @site = site

    I18n.with_locale(user.locale) do
      mail(
        to: user.email,
        subject: I18n.t(:notify_site_owner_new_comment_mail_subject)
      )
    end
  end
end
