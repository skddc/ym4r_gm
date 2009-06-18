
Ym4r::GmPlugin::GPolyline.class_eval do
  #Creates a GPolyline object from a georuby line string. Assumes the points of the line strings are stored in Longitude(x)/Latitude(y) order.
  def self.from_georuby(line_string,color = nil,weight = nil,opacity = nil)
    GPolyline.new(line_string.points.collect { |point| GLatLng.new([point.y,point.x])},color,weight,opacity)
  end
end

Ym4r::GmPlugin::GMarker.class_eval do
  #Creates a GMarker object from a georuby point. Accepts the same options as the GMarker constructor. Assumes the points of the line strings are stored in Longitude(x)/Latitude(y) order.
  def self.from_georuby(point,options = {})
    GMarker.new([point.y,point.x],options)
  end
end

Ym4r::GmPlugin::GLatLng.class_eval do
  #Creates a GLatLng object from a georuby point. Assumes the points of the line strings are stored in Longitude(x)/Latitude(y) order.
  def self.from_georuby(point,unbounded = nil)
    GLatLng.new([point.y,point.x],unbounded)
  end
end

Ym4r::GmPlugin::GLatLngBounds.class_eval do
  #Creates a GLatLng object from a georuby point. Assumes the points of the line strings are stored in Longitude(x)/Latitude(y) order.
  def self.from_georuby(envelope)
    GLatLngBounds.new(GLatLng.from_georuby(envelope.lower_corner),
                      GLatLng.from_georuby(envelope.upper_corner))
  end
end

Ym4r::GmPlugin::GPolygon.class_eval do
  #Creates a GPolygon object from a georuby polygon or line string. Assumes the points of the line strings are stored in Longitude(x)/Latitude(y) order.
  def self.from_georuby(ls_or_p, stroke_color="#000000",stroke_weight=1,stroke_opacity=1.0,color="#ff0000",opacity=1.0)
    if ls_or_p.is_a?(GeoRuby::SimpleFeatures::LineString)
      GPolygon.new(ls_or_p.collect { |point| GLatLng.new([point.y,point.x])},stroke_color,stroke_weight,stroke_opacity,color,opacity)
    else
      GPolygon.new(ls_or_p[0].collect { |point| GLatLng.new([point.y,point.x])},stroke_color,stroke_weight,stroke_opacity,color,opacity)
    end
  end
end

Ym4r::GmPlugin::GPolylineEncoded.class_eval do
  def self.from_georuby(line_string, color = nil, weight = nil, opacity = nil)
    encoded_points = GMapPolylineEncoder.new.encode(
      line_string.points.collect {|p| [p.y, p.x]})
    GPolylineEncoded.new(
      :points => encoded_points[:points],
      :levels => encoded_points[:levels],
      :num_levels => encoded_points[:numLevels],
      :zoom_factor => encoded_points[:zoomFactor],
      :color => color,
      :weight => weight,
      :opacity => opacity
    )
  end
end

Ym4r::GmPlugin::GPolygonEncoded.class_eval do
  def self.from_georuby(ls_or_p, stroke_color="#000000",stroke_weight=1,stroke_opacity=1.0,color="#ff0000",opacity=1.0)
    if ls_or_p.is_a?(GeoRuby::SimpleFeatures::LineString)
      GPolygonEncoded.new(
        GPolylineEncoded.from_georuby(ls_or_p, stroke_color, stroke_weight, stroke_opacity), 
        color.nil?, color, opacity, stroke_weight > 0)
    else
      polylines = ls_or_p.rings.collect do |line_string|
        GPolylineEncoded.from_georuby(line_string, stroke_color, 
          stroke_weight, stroke_opacity)
      end
      GPolygonEncoded.new(polylines, true, color, opacity, true)
    end
  end
end
