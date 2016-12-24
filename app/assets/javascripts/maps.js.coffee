
$ ->
  google.maps.Polygon.prototype.getBounds = ->
    bounds = new google.maps.LatLngBounds()
    paths = @getPaths()
    for path, i in paths
      path = paths.getAt i
      for point, j in path
        point = path.getAt j
        bounds.extend point    
    bounds

  $("div[data-map-detail]").each ->
    site = $(this).data("map-marker")

    mapOptions =
      center: new google.maps.LatLng(site.latitude , site.longitude)
      zoom: 16


    map = new google.maps.Map(this, mapOptions);

    marker = new google.maps.Marker({
        position: new google.maps.LatLng(site.latitude, site.longitude),
        map: map,
        title: site.name,
        icon: site.icon_url
    });

  $("div[data-map-zone]").each ->
    boundary = $(this).data("map-boundary")

    mapOptions =
      center: new google.maps.LatLng(0, 0)
      zoom: 1

    map = new google.maps.Map(this, mapOptions)
    path = (new google.maps.LatLng(point[0], point[1]) for point in boundary)
    console.log(path)

    polygon = new google.maps.Polygon(
      paths: path
      map: map
      strokeColor: '#555'
      strokeOpacity: 0.8
      strokeWeight: 2
      fillOpacity: '#555'
      fillOpacity: 0.35
    )
    
    bounds = polygon.getBounds()
    map.fitBounds bounds

