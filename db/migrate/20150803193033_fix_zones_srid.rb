class FixZonesSrid < ActiveRecord::Migration
  def up
    update 'update zones set polygon = ST_SetSRID(polygon, 4326)'
    execute "select UpdateGeometrySRID('public', 'zones', 'polygon', 4326)"
  end
end
