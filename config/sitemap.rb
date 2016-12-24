# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.bicimapa.com"

SitemapGenerator::Sitemap.create do

  I18n.available_locales.each do |locale|
    next if locale == :dummy
    group(:sitemaps_path => 'sitemaps/', :filename => locale) do
      Site.find_each do |site|
        add site_path(locale, site), :lastmod => site.updated_at, :priority => 1
      end
    end
  end
end
