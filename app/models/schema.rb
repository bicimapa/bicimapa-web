SiteType = GraphQL::ObjectType.define do
  name 'Site'
  description '...'

  field :id, !types.ID
  field :name, !types.String
  field :longitude, !types.Float
  field :latitude, !types.Float
  field :distance, !types.Float
  field :path, !types.String do
	resolve -> (obj, args, ctx) {
		Rails.application.routes.url_helpers.site_path(id: obj.id, locale: nil)
	}
  end

end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The root of all queries'

  field :nearSites do
    type types[SiteType]
    argument :lat, !types.Float
    argument :lng, !types.Float
    argument :category_id, !types.ID
    argument :limit, types.Int

    resolve -> (obj, args, ctx) {
      lat = args[:lat]
      lng = args[:lng]
      category_id = args[:category_id]
      limit = args[:limit] || 10

      query = %{
        select 
        ST_Distance(ST_GeomFromText('POINT(#{lng} #{lat})',4326), s.lonlat) distance,
        s.* 
        from sites s 
        join categories c on s.category_id = c.id
        where 
        s.is_active 
        and s.deleted_at is null
        and c.id = #{category_id}
        order by distance asc
        limit #{limit}
      }

      sites = Site.find_by_sql(query)

      return sites
    }
  end

  field :sites do
    type types[SiteType]
    resolve -> (obj, args, ctx) { Site.all }
  end

  field :site do
    type SiteType
    description 'The site associated with a given ID'
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { Site.find(args[:id]) }
  end

end

Schema = GraphQL::Schema.define do
  query QueryType
end
