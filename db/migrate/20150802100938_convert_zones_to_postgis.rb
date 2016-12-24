class ConvertZonesToPostgis < ActiveRecord::Migration
  def up
    add_column :zones, :polygon, :st_polygon
    
    update %{
      update zones set polygon = p.polygon
      from  
      (select t.id, ST_SetSRID(ST_GeomFromText('POLYGON((' || t.wkt || ', ' || left(t.wkt, strpos(t.wkt, ',') - 1) || '))'), 4326) as polygon from (
      select q.id, string_agg(q.lon || ' ' || q.lat, ',') as wkt from (
      select id, json_array_elements(points::json)->0 as lat, json_array_elements(points::json)->1 as lon from zones
      ) q
      group by q.id
      ) t) p
      where zones.id = p.id  
    }

    remove_column :zones, :points
  end
end
