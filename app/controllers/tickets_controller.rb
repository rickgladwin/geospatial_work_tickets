require 'net/http'
require 'uri'

class TicketsController < ApplicationController
  def index
    @tickets = Ticket.all
  end

  def show
    @ticket = Ticket.find(params[:id])
    puts "$$$$$$$$$$$$ #{@ticket.digsite_info}"
    @polygon_center = center_of_polygon(polygon_string_to_array(@ticket.digsite_info))
    puts "polygon_center: #{@polygon_center}"
    # maps_api_key = Rails.application.credentials.google_maps_api_key
    # maps_api_key = "#{Rails.application.credentials.google_maps_api_key}"
    maps_api_key = Rails.application.credentials.google_maps_api_key
    @maps_api_key = maps_api_key

    puts "api key: #{maps_api_key}"
    # static_map_uri = URI(static_google_map(polygon_string_to_array(@ticket.digsite_info)))
    static_map_uri = URI(static_google_map_with_polygon(@ticket.digsite_info))

    # https_connection = Net::HTTP.new(static_map_uri.host, static_map_uri.port)

    http = Net::HTTP.new(static_map_uri.host, static_map_uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    @static_map_uri = static_map_uri

    request = Net::HTTP::Get.new(static_map_uri)
    request["x-api-key"] = Rails.application.credentials.google_maps_api_key
    request["cache-control"] = 'no-cache'
    response = http.request(request)
    @response_body = response.read_body

  end

  def polygon_string_to_array(polygon_coords)
    # example input
    # ((-81.13390268058475,32.07206917625161),(-81.14660562247929,32.04064386441295),(-81.08858407706913,32.02259853170128),(-81.05322183341679,32.02434500961698),(-81.05047525138554,32.042681017283066),(-81.0319358226746,32.06537765335268),(-81.01202310294804,32.078469305179404),(-81.02850259513554,32.07963291684719),(-81.07759774894413,32.07090546831167),(-81.12154306144413,32.08806865844325),(-81.13390268058475,32.07206917625161))
    # example output
    # [
    #   {
    #     lat: -81.13390268058475,
    #     lon: 32.07206917625161,
    #   },
    #   {
    #     lat: -81.14660562247929,
    #     lon: 32.04064386441295,
    #   },
    # ]
    polygon_array = []
    coords_pairs = polygon_coords.delete_prefix('(').delete_suffix(')')
    coord_pair_regex = /\((-?\d+\.?\d*\,\-?\d+\.?\d*)\)/
    matches = coords_pairs.scan(coord_pair_regex)
    matches.each do |pair_array|
      pair = pair_array[0].split(',')
      polygon_array << {
        lat: pair[0].to_f,
        lon: pair[1].to_f,
      }
    end

    polygon_array
  end

  def polygon_string_to_google_maps_path(polygon_coords)
    # example input
    # ((-81.13390268058475,32.07206917625161),(-81.14660562247929,32.04064386441295),(-81.08858407706913,32.02259853170128),(-81.05322183341679,32.02434500961698),(-81.05047525138554,32.042681017283066),(-81.0319358226746,32.06537765335268),(-81.01202310294804,32.078469305179404),(-81.02850259513554,32.07963291684719),(-81.07759774894413,32.07090546831167),(-81.12154306144413,32.08806865844325),(-81.13390268058475,32.07206917625161))
    # example output
    # |-81.13390268058475,32.07206917625161|-81.14660562247929,32.04064386441295|-81.08858407706913,32.02259853170128|-81.05322183341679,32.02434500961698
    google_maps_path = ""
    coords_pairs = polygon_coords.delete_prefix('(').delete_suffix(')')
    coord_pair_regex = /\((-?\d+\.?\d*\,\-?\d+\.?\d*)\)/
    matches = coords_pairs.scan(coord_pair_regex)
    matches.each do |pair_array|
      pair = pair_array[0].split(',')
      google_maps_path += "|#{pair[0].to_f},#{pair[1].to_f}"
    end

    google_maps_path
  end

  def center_of_polygon(polygon_array)
    lat_sum = 0.0
    lon_sum = 0.0
    polygon_array.each do |lat_lon|
      lat_sum += lat_lon[:lat]
      lon_sum += lat_lon[:lon]
    end
    {
      lat: lat_sum / polygon_array.size,
      lon: lon_sum / polygon_array.size,
    }
  end

  def static_google_map(coordinates)
    # set the initial zoom on the Google Map based on the size of the polygon
    latitudes = coordinates.map { |lat_long_pair| lat_long_pair[:lat] }
    longitudes = coordinates.map { |lat_long_pair| lat_long_pair[:lon] }
    lat_delta = latitudes.max - latitudes.min
    lon_delta = longitudes.max - longitudes.min
    max_delta = [lat_delta, lon_delta].max

    puts "max_delta: #{max_delta}"

    # Google Maps zoom range: 0..15 or 21 or 23, depending on the map
    # Set the zoom value as a function of the largest dimension (lat or long)
    # of the polygon
    # TODO: tweak the zoom_coefficient to encompass the entire polygon plus a buffer
    zoom_coefficient = 100
    zoom = (max_delta * zoom_coefficient).round(0)

    puts "zoom: #{zoom}"

    # map_center = "Brooklyn+Bridge,New+York,NY"
    coordinates_center = center_of_polygon(coordinates)
    map_center = "#{coordinates_center[:lat]},#{coordinates_center[:lon]}"
    puts "map_center: #{map_center}"

    # "https://maps.googleapis.com/maps/api/staticmap?center=#{map_center}&size=500x500&zoom=17&key=#{Rails.application.credentials.google_maps_api_key}"
    # https://maps.googleapis.com/maps/api/staticmap?center=43.6567332,-79.381446&size=500x500&zoom=15&key=AIzaSyAYlNyJl_FswjxVX8vO5PPESzmcf4fNSRU
    # "https://maps.googleapis.com/maps/api/staticmap?center=#{map_center}&size=500x500&zoom=17&key=AIzaSyAYlNyJl_FswjxVX8vO5PPESzmcf4fNSRU"
    # "https://maps.googleapis.com/maps/api/staticmap?center=#{map_center}&size=500x500&zoom=#{zoom}&key=AIzaSyAYlNyJl_FswjxVX8vO5PPESzmcf4fNSRU"
    # "https://maps.googleapis.com/maps/api/staticmap?center=#{map_center}&size=500x500&zoom=#{zoom}&key=#{Rails.application.credentials.google_maps_api_key}"
    "https://maps.googleapis.com/maps/api/staticmap?center=#{map_center}&size=500x500&zoom=#{zoom}&key=#{Rails.application.credentials.google_maps_api_key}"
  end

  def static_google_map_with_polygon(polygon_string)
    path_string = "color:0x0000ff|fillcolor:0x12342f|weight:5#{polygon_string_to_google_maps_path(polygon_string)}"
    # path_string = "color:0x0000ff|fillcolor:0x12342f|weight:5|40.737102,-73.990318|40.749825,-74.987963|40.752946,-73.987384|40.255823,-73.986397"
    # "https://maps.googleapis.com/maps/api/staticmap?center=#{map_center}&size=500x500&zoom=#{zoom}&key=#{Rails.application.credentials.google_maps_api_key}"
    "https://maps.googleapis.com/maps/api/staticmap?&size=500x500&path=#{path_string}&key=#{Rails.application.credentials.google_maps_api_key}"
  end
end
