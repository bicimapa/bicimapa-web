class ConvertLinesToPostgis < ActiveRecord::Migration
  def up
    execute "delete from lines where points = ''"

    add_column :lines, :path, :line_string, srid: 4326 
     
    Line.all.each do |l|
      l.path = 'LINESTRING(' + JSON.parse(l.points).map {|p| p[1].to_s + ' ' + p[0].to_s}.join(',')  + ')'
      l.save
    end

    remove_column :lines, :points
  end
end
