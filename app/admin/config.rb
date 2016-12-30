ActiveAdmin.register_page "Configuration" do

  menu label: "Configuration", priority: 100

  content title: "Congiguration" do
    columns do
      column do
        panel "Facebook" do
          div class: "attributes_table" do
            table do
              tbody do
                tr do
                  th "App ID"
                  td ENV['FACEBOOK_APP_ID']
                end
                tr do
                  th "App Secret"
                  td ENV['FACEBOOK_SECRET_ID']
                end
              end
            end
          end
        end
      end

      column do
        panel "Google" do
          div class: "attributes_table" do
            table do
              tbody do
                tr do
                  th "Map API Key"
                  td ENV['GOOGLE_MAP_API_KEY']
                end
                tr do
                  th "Analytics Tracker"
                  td ENV['GOOGLE_ANALYTICS_TRACKER']
                end
              end
            end
          end
        end
      end

    end

    columns do

      column do
        panel "Twitter" do
          div class: "attributes_table" do
            table do
              tbody do
                tr do
                  th "Consumer key"
                  td ENV['TWITTER_CONSUMER_KEY']
                end
                tr do
                  th "Consumer secret"
                  td ENV['TWITTER_CONSUMER_SECRET']
                end
                tr do
                  th "Access token"
                  td ENV['TWITTER_ACCESS_TOKEN']
                end
                tr do
                  th "Access token secret"
                  td ENV['TWITTER_ACCESS_TOKEN_SECRET']
                end
              end
            end
          end
        end
      end

    end
  end
end
