class FixLatLngTypo < ActiveRecord::Migration
  def change
	  rename_column :sites, :latitud, :latitude
	  rename_column :sites, :longitud, :longitude
  end
end
