class Admin::ImportController < Admin::AdminController
  def kml
  end

  def selection
    ext = File.extname(params[:file].original_filename).delete('.')

    unless 'kml'.casecmp(ext) == 0 || 'kmz'.casecmp(ext) == 0
      redirect_to({ action: 'kml' }, notice: 'Must be kml (or kmz) file')
    end

    kml_content = ''

    if 'kmz'.casecmp(ext) == 0

      require 'zip'
      Zip::File.open(params[:file].tempfile) do |zip_file|
        entry = zip_file.glob('*.kml').first
        kml_content = entry.get_input_stream.read
      end

    else
      kml_content = params[:file].read
    end

    require 'nokogiri'

    doc = Nokogiri::XML(kml_content)
    doc.remove_namespaces!

    @sites = []

    placemarks = doc.xpath('//Point')

    placemarks.each do |placemark|
      coords = placemark.at_xpath('coordinates').text.split(',').first(2).reverse
      @sites << coords
    end

    gon.sites = @sites

    session[:sites] = @sites

    @lines = []

    linestrings = doc.xpath('//LineString')

    linestrings.each do |linestring|
      coords = linestring.at_xpath('coordinates').text.split(' ')

      coords.map! do |coord|
        coord.split(',').first(2).reverse
      end

      @lines << coords
    end

    gon.lines = @lines

    session[:lines] = @lines
  end

  def import
    sites_name = params[:sites_name]
    sites_desc = params[:sites_desc]
    sites_category_id = params[:sites_category_id]

    Site.transaction do
      session[:sites].each do |site|
        s = Site.new
        s.name = sites_name
        s.description = sites_desc
        s.category_id = sites_category_id
        s.lonlat = "POINT(#{site[1]} #{site[0]})"
        s.has_been_reviewed = true
        s.is_active = true
        s.origin = 'IMP'

        s.save
      end
    end

    lines_name = params[:lines_name]
    lines_desc = params[:lines_desc]
    lines_category_id = params[:lines_category_id]

    Line.transaction do
      session[:lines].each do |line|
        l = Line.new
        l.name = lines_name
        l.description = lines_desc
        l.category_id = lines_category_id

        path = 'LINESTRING('

        tmp = line.shift

        path << "#{tmp[1]} #{tmp[0]}"

        line.each do |tmp|
          path << ",#{tmp[1]} #{tmp[0]}"
        end

        path << ')'

        l.path = path

        l.is_active = true
        l.origin = 'IMP'

        l.save
      end
    end

    redirect_to controller: 'admin/static', action: 'index'
  end
end
