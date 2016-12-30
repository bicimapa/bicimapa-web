class ConvertReportsToPostgis < ActiveRecord::Migration
  def up
    add_column :reports_reports, :lonlat, :st_point, geographic: true
    update "UPDATE reports_reports SET lonlat = ST_SetSRID(ST_Point(longitude, latitude),4326)::geography"
    remove_column :reports_reports, :latitude
    remove_column :reports_reports, :longitude
  end

  def down
    add_column :reports_reports, :latitude, :decimal
    add_column :reports_reports, :longitude, :decimal
    update "UPDATE reports_reports SET longitude = ST_x(lonlat::geometry), latitude = ST_y(lonlat::geometry)"
    remove_column :reports_reports, :lonlat
  end
end
