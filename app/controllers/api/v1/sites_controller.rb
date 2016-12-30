module Api
  module V1
    class SitesController  < ActionController::Base
      def index
        @sites = Site.with_deleted.all
      end

      def show
        @site = Site.find(params[:id])
      end

      def stats
        @site = Site.find(params[:id])
      end

      def pictures
        @site = Site.find(params[:id])
      end

      def comments
        @comments = Site.find(params[:id]).comments
      end

      def comment
	@site = Site.find params[:id]
	comment = @site.comments.create
	comment.comment = params[:comment]
	comment.user = User.find_by_token params[:token]

	comment.save

        render json: {result: "ok"}
      end

      def count
        categories_id = params[:categories].split(",").map(&:to_i)

        sw = params[:sw].split(",")
        ne = params[:ne].split(",")

        lng = 1
        lat = 0

        viewport = "POLYGON((#{sw[lng]} #{ne[lat]},#{ne[lng]} #{ne[lat]},#{ne[lng]} #{sw[lat]},#{sw[lng]} #{sw[lat]},#{sw[lng]} #{ne[lat]}))"

        count = Site.joins(:category).where('sites.is_active' => true, 'categories.is_active' => true, 'sites.category_id' => categories_id).where(["ST_WITHIN(sites.lonlat::geometry, ST_PolygonFromText(?, 4326))", viewport]).count
        render json: { count: count }
      end

      def get

        categories_id = "NULL"
        categories_id = params[:categories] if params[:categories].present?

        sw = params[:sw].split(",")
        ne = params[:ne].split(",")

        lng = 1
        lat = 0

        viewport = "POLYGON((#{sw[lng]} #{ne[lat]},#{ne[lng]} #{ne[lat]},#{ne[lng]} #{sw[lat]},#{sw[lng]} #{sw[lat]},#{sw[lng]} #{ne[lat]}))"

        query_sites = %{
        select row_to_json(q) as json from (
            select COALESCE(array_to_json(array_agg(row_to_json(t))), '[]') as sites from (
                    select s.id, s.name,
                    COALESCE(
                      '/system/sites/custom_icons/' ||
                      substring(lpad(s.id::text, 9, '0') from 1 for 3) || '/' || 
                      substring(lpad(s.id::text, 9, '0') from 4 for 3) || '/' ||
                      substring(lpad(s.id::text, 9, '0') from 7 for 3) || '/original/' || s.custom_icon_file_name || '?' || EXTRACT(EPOCH FROM date_trunc('second', s.custom_icon_updated_at))
                    ,
                      '/system/categories/icons/' ||
                      substring(lpad(c.id::text, 9, '0') from 1 for 3) || '/' || 
                      substring(lpad(c.id::text, 9, '0') from 4 for 3) || '/' ||
                      substring(lpad(c.id::text, 9, '0') from 7 for 3) || '/original/' || c.icon_file_name || '?' || EXTRACT(EPOCH FROM date_trunc('second', c.icon_updated_at))
                    ) as icon_url,
                    ST_X(s.lonlat::geometry) longitude,
                    ST_Y(s.lonlat::geometry) latitude
                    from sites s 
                    join categories c on c.id = s.category_id and c.deleted_at is NULL 
                    where s.deleted_at is NULL
                    and s.is_active = 't'
                    and c.is_active = 't'
                    and c.id IN (#{categories_id})
                    and (ST_WITHIN(s.lonlat::geometry, ST_PolygonFromText('#{viewport}', 4326)))
            ) t
            ) q
        }

        results = Site.connection.execute(query_sites)
        @sites_as_json = results.first['json'].html_safe

        render json: @sites_as_json

      end

      def cluster
        
        zoom = params[:zoom].to_i
        delta = 40
        delta = delta/zoom unless zoom == 0
    
        query_cluster = %{
          select array_to_json(array_agg(row_to_json(p))) as json from (
          SELECT t.count, ST_y(t.center) latitude, ST_x(t.center) longitude FROM (
          SELECT
              COUNT( s.lonlat ) AS count,
              ST_AsText( ST_Centroid(ST_Collect( s.lonlat::geometry )) ) AS center
          FROM sites s
          join categories c on c.id = s.category_id
          where s.deleted_at is null
          and s.is_active = 't'
          and c.deleted_at is null
          and c.is_active = 't'
          GROUP BY
              ST_SnapToGrid( lonlat::geometry, #{delta}, #{delta})
          ) t
          ORDER BY
              count DESC
          ) p
        }

        results = Site.connection.execute(query_cluster)
        @cluster_as_json = (results.first['json'] || '{}').html_safe

        render json: @cluster_as_json
      end

      def create
        @site = Site.new(site_params)

        @site.origin = 'API'

        params.permit(:token)
        @site.user = User.find_by_token params[:token]

        respond_to do |format|
          if @site.save
            format.html { render nothing: true }
            format.json { render nothing: true }
          else
            format.html { render :new }
            format.json { render json: @site.errors, status: :unprocessable_entity }
          end
        end
      end

      def near
        lat, lng = params[:ll].split(',')
        origin = Geokit::LatLng.new(lat, lng)
        @sites = Site.all.within(0.300, origin: origin).where('sites.is_active' => true)

        @sites = @sites.sort_by do |site|
          p = Geokit::LatLng.new(site.latitude, site.longitude)
          (p.distance_to(origin,  unit: :kms ) * 1000).round
        end
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def site_params
        params.require(:site).permit(:name, :description, :latitude, :longitude, :is_active, :deleted_at, :category_id, :has_been_reviewed)
      end
    end
  end
end
