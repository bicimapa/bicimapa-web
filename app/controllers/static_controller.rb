class StaticController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :authorize_page

  def index
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

  private

  def authorize_page
    authorize :static, :show?
  end

end
