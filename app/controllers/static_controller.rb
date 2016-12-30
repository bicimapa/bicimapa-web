class StaticController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @pos = nil
    unless params[:pos].nil?
      param = params[:pos].split(',')
      @pos = {
        latitude: param[0],
        longitude: param[1]
      }
    end

    @zoom = 2
    @zoom = params[:zoom] || 15 if params[:pos]
    
    @filters = nil
    @filters = params[:categories].split(",").map(&:to_i) if params[:categories]

    @reports = nil
    @reports = params[:reports] if params[:reports]

    @bicimappers_count = User.count + Newsletter.where('newsletters.email not in (select users.email from users)').count

    @categories = Category.all.where(:is_active => true)

    query_lines = %{
    select array_to_json(array_agg(row_to_json(t))) as json
          from (
          select 
            l.id, l.name, St_AsGeoJSon(l.path)::json->'coordinates' as path, l.category_id 
          from 
            lines l
          join 
            categories c on c.id = l.category_id
          where
            l.is_active = true 
          and l.deleted_at is null
          and c.is_active = true 
          and c.deleted_at is null
            ) t
    }

    results = Line.connection.execute(query_lines)
    @lines_as_json = (results.first['json'] || '{}' ).html_safe

    query_reports = %{
      select array_to_json(array_agg(row_to_json(t))) as json from ( 
      select id, description, latitude, longitude from (
      select r.id, r.description, r.latitude, r.longitude, ss.is_final_state, rank() OVER (PARTITION BY r.id ORDER BY s.created_at DESC) R
      from reports_reports r
      join reports_states s on s.report_id = r.id
      join reports_statuses ss on ss.code = s.status_code
      ) p
      where p.R = 1 and is_final_state = 'f'
      ) t
    }
    results = Reports::Report.connection.execute(query_reports)
    @reports_as_json = (results.first['json'] || '{}').html_safe

    gon.filters = @filters
    gon.showReports = @reports
    gon.pos = @pos
    gon.zoom = @zoom.to_i
    gon.root_url = url_for :root
    gon.marker_url = ActionController::Base.helpers.image_path 'marker-location.png'
    gon.new_site_url = new_site_path
    gon.show_site_url = show_site_path
    gon.show_site_label = I18n.t :show_site_label
    gon.new_site_label = I18n.t :add_new_site
    gon.new_report_url = new_report_path
    gon.new_report_label = I18n.t :add_new_report
    gon.show_report_url = reports_path
    gon.show_report_label = I18n.t :show_report_label

    gon.nothing_found_label = I18n.t :nothing_found
    gon.multiple_results_label = I18n.t :multiple_results

    gon.categories = {}
    @categories.each do |category|
      gon.categories[category.id] = {
        icon: category.icon.url,
        color: category.color,
        variety: category.variety,
        is_initial: category.is_initial
      }
    end

    render layout: false
  end

  def tos
  end

  def team
    @moderators = User.find_by_sql("select distinct u.* from moderators_zones mz join users u on u.id = mz.moderator_id")
  end

  def press
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    end

    bicimapa = client.user('bicimapa')
    @followers_count = bicimapa.followers_count
  end

  def ranking
    @users_all_time = User.sort_by_rank_desc
    @users_last_week = User.sort_by_rank_desc_this_week.take 3
  end

  def api
    case params[:api]
      when "lugares" then
	categories = "1,2,3,5,6,7"
	categories = "1,2,3,5,6,7,8" if params[:"10"] == "on"
	
      	query_sites = %{
		select array_to_json(array_agg(row_to_json(t))) as json
			from (
					select s.id, s.name as nombre, s.name as nombrelimpio, s.description as descripcion, ST_Y(s.lonlat::geometry) as longitud, ST_X(s.lonlat::geometry) as latitud, s.category_id as tipo, '' as ruta from sites s join categories c on c.id = s.category_id where s.category_id in (#{categories}) and s.deleted_at is null and s.is_active = 't' and c.deleted_at is null and c.is_active = 't'
			     ) t
	}

	results = Site.connection.execute(query_sites)
	@json = results.first['json'].html_safe

      	render :json => @json, :layout => false 
	return
      when "ciclorrutas" then
        @file_name = "#{Rails.root}/ciclorrutas.json"
      when "ciclovias" then
        @file_name = "#{Rails.root}/ciclovias.json"
      when "calificacion" then
	site = Site.find(params[:id])
	render :json => { numero_calificaciones: site.nb_rating   ,calificacion: site.rating}, :layout => false
	return
    end

    render :file => @file_name, :layout => false
  end

  def agregar
	latlong = params[:latlong].split(",")

	site = Site.new
	site.name = params[:nombre].force_encoding('iso-8859-1').encode('utf-8')
	site.description = params[:descripcion].force_encoding('iso-8859-1').encode('utf-8')
	factory = RGeo::Geographic.spherical_factory(srid: 4326)
	lonlat = factory.point(latlong[1], latlong[0])
	site.lonlat = lonlat
	site.has_been_reviewed = false
	site.is_active = true
  site.user = User.find_by_email(params[:email])
	site.origin = 'API' 
	site.category = Category.find(params[:tipo])
	site.save
	
	render :nothing => true
  end

end
