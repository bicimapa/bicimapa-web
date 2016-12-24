namespace :bicimapa do
  desc 'Notify pending approvals to moderators'
  task notify: :environment do
    Zone.all.each do |zone|
      print "Processing #{zone.name}"

      sites = Site.where(has_been_reviewed: false).where(['ST_Within(sites.lonlat::geometry, ?)', zone.polygon]).all

      if sites.count == 0
        puts "\tNothing new there"
      else
        puts "\tNotified #{sites.count} new sites"
        zone.moderators.each do |moderator|
          DefaultMailer.notify_pending_review(moderator, zone, sites.count).deliver
        end
      end
    end
  end
end
