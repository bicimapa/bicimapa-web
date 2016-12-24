class ConvertToPostGis < ActiveRecord::Migration
  def up
    add_column :sites, :lonlat, :st_point, geographic: true
    update "UPDATE sites SET lonlat = ST_SetSRID(ST_Point(longitude, latitude),4326)::geography"
    remove_column :sites, :latitude
    remove_column :sites, :longitude
  end

  def down
    add_column :sites, :latitude, :decimal
    add_column :sites, :longitude, :decimal
    update "UPDATE sites SET longitude = ST_x(lonlat::geometry), latitude = ST_y(lonlat::geometry)"
    remove_column :sites, :lonlat
  end
end
