# frozen_string_literal: true

require 'tickets_controller'

describe TicketsController do
  tickets_controller = TicketsController.new

  describe 'polygon_string_to_array' do
    it "converts a valid polygon string to an array of hashes" do
      test_polygon_coords = '((-81.13390268058475,32.07206917625161),(-81.14660562247929,32.04064386441295),(-81.08858407706913,32.02259853170128))'
      expected_result     = [
        {
          lat: -81.13390268058475,
          lon: 32.07206917625161,
        },
        {
          lat: -81.14660562247929,
          lon: 32.04064386441295,
        },
        {
          lat: -81.08858407706913,
          lon: 32.02259853170128,
        }
      ]
      result              = tickets_controller.polygon_string_to_array(test_polygon_coords)
      expect(result).to eq expected_result
    end
  end

  describe 'polygon_string_to_google_maps_path' do
    it 'converts a polygon string to a google maps path string' do
      test_polygon_coords = '((-81.13390268058475,32.07206917625161),(-81.14660562247929,32.04064386441295),(-81.08858407706913,32.02259853170128),(-81.05322183341679,32.02434500961698))'
      expected_result = "|-81.13390268058475,32.07206917625161|-81.14660562247929,32.04064386441295|-81.08858407706913,32.02259853170128|-81.05322183341679,32.02434500961698"
      result = tickets_controller.polygon_string_to_google_maps_path(test_polygon_coords)
      expect(result).to eq expected_result
    end
  end

  describe 'polygon_center' do
    it 'gets the center of a polygon' do
      lat_1 = -81.13390268058475
      lat_2 = -81.14660562247929
      lat_3 = -81.08858407706913

      lon_1 = 32.07206917625161
      lon_2 = 32.04064386441295
      lon_3 = 32.02259853170128

      test_input      = [
        {
          lat: lat_1,
          lon: lon_1,
        },
        {
          lat: lat_2,
          lon: lon_2,
        },
        {
          lat: lat_3,
          lon: lon_3,
        }
      ]
      expected_result = {
        lat: (lat_1 + lat_2 + lat_3) / 3,
        lon: (lon_1 + lon_2 + lon_3) / 3,
      }
      result          = tickets_controller.center_of_polygon(test_input)
      # puts "polygon center: #{result}"
      expect(result).to eq expected_result
    end
  end

  describe 'static_google_map' do
    it 'generates an https URL to use with the Google Maps Static Map API' do
      test_coords = [
        {
          lat: 32.07206917625161,
          lon: -81.13390268058475,
        },
        {
          lat: 32.04064386441295,
          lon: -81.14660562247929,
        },
        {
          lat: 32.02259853170128,
          lon: -81.08858407706913,
        },
        {
          lat: 32.02434500961698,
          lon: -81.05322183341679,
        },
        {
          lat: 32.042681017283066,
          lon: -81.05047525138554,
        },
        {
          lat: 32.06537765335268,
          lon: -81.0319358226746,
        },
        {
          lat: 32.078469305179404,
          lon: -81.01202310294804,
        },
        {
          lat: 32.07963291684719,
          lon: -81.02850259513554,
        },
        {
          lat: 32.07090546831167,
          lon: -81.07759774894413,
        },
        {
          lat: 32.08806865844325,
          lon: -81.12154306144413,
        },
        {
          lat: 32.07206917625161,
          lon: -81.13390268058475,
        },
      ]

      result = tickets_controller.static_google_map(test_coords)
      # puts result
      expect(result).to be_a String
      expect(result[0..7]).to eq 'https://'
    end
  end
end
