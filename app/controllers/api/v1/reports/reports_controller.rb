module Api
  module V1
    module Reports
      class ReportsController  < ActionController::Base

        def get

          sw = params[:sw].split(",")
          ne = params[:ne].split(",")

          lng = 1
          lat = 0

          viewport = "POLYGON((#{sw[lng]} #{ne[lat]},#{ne[lng]} #{ne[lat]},#{ne[lng]} #{sw[lat]},#{sw[lng]} #{sw[lat]},#{sw[lng]} #{ne[lat]}))"

          query_reports = %{
        select row_to_json(q) as json from (
            select COALESCE(array_to_json(array_agg(row_to_json(t))), '[]') as reports from (
                    select r.id,
                    ST_X(r.lonlat::geometry) longitude,
                    ST_Y(r.lonlat::geometry) latitude
                    from reports_reports r 
                    where (ST_WITHIN(r.lonlat::geometry, ST_PolygonFromText('#{viewport}', 4326)))
            ) t
            ) q
          }

          results = ::Reports::Report.connection.execute(query_reports)
          @reports_as_json = results.first['json'].html_safe

          render json: @reports_as_json

        end

      end
    end
  end
end
