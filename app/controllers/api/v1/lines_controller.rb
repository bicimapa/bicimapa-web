module Api
  module V1
    class LinesController  < ActionController::Base

      def get

        categories_id = "NULL"
        categories_id = params[:categories] if !params[:categories].empty?


        sw = params[:sw].split(",")
        ne = params[:ne].split(",")

        lng = 1
        lat = 0

        viewport = "POLYGON((#{sw[lng]} #{ne[lat]},#{ne[lng]} #{ne[lat]},#{ne[lng]} #{sw[lat]},#{sw[lng]} #{sw[lat]},#{sw[lng]} #{ne[lat]}))"

        query_lines = %{
          select row_to_json(q) as json from
          (
              select COALESCE(array_to_json(array_agg(row_to_json(t))), '[]') as lines
                    from (
                       select 
                         l.id, c.color, St_AsGeoJSon(ST_FlipCoordinates(l.path))::json->'coordinates' as path 
                       from 
                         lines l
                       join 
                         categories c on c.id = l.category_id
                       where
                         l.is_active = true 
                       and l.deleted_at is null
                       and c.is_active = true 
                       and c.deleted_at is null
                       and c.id IN (#{categories_id})
                       and ST_INTERSECTS(l.path::geometry, ST_PolygonFromText('#{viewport}', 4326))
                    ) t
          )q
        }

        results = Line.connection.execute(query_lines)
        @lines_as_json = results.first['json'].html_safe

        render json: @lines_as_json
      end

    end
  end
end
