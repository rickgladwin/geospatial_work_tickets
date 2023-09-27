# frozen_string_literal: true

describe Api::V1::TicketDataController do
  ticket_data_controller = Api::V1::TicketDataController.new

  describe "validate_well_known_text" do
    it "invalidates well_known_text missing POLYGON prefix" do
      test_value = 'INCORRECT((12345 345567, 234234 -56.788))'
      result = ticket_data_controller.validate_well_known_text(test_value)
      expect(result[:status]).to eq false
    end

    it "invalidates well_known_text with fewer than 3 polygon points" do
      test_value = 'POLYGON((58.835 -123.987,55.2 -125.67))'
      result = ticket_data_controller.validate_well_known_text(test_value)
      expect(result[:status]).to eq false
    end

    it "invalidates well_known_text with extra leading spaces" do
      test_value = 'POLYGON(( 56.23 -123.456,58.835 -123.987,55.2 -125.67))'
      result = ticket_data_controller.validate_well_known_text(test_value)
      expect(result[:status]).to eq false
    end

    it "invalidates well_known_text with extra trailing spaces" do
      test_value = 'POLYGON((56.23 -123.456,58.835 -123.987,55.2 -125.67 ))'
      result = ticket_data_controller.validate_well_known_text(test_value)
      expect(result[:status]).to eq false
    end

    it "invalidates well_known_text with spaces after commas" do
      test_value = 'POLYGON((56.23 -123.456, 58.835 -123.987, 55.2 -125.67))'
      result = ticket_data_controller.validate_well_known_text(test_value)
      expect(result[:status]).to eq false
    end

    it "validates well_known_text" do
      test_value = 'POLYGON((56.23 -123.456,58.835 -123.987,55.2 -125.67))'
      result = ticket_data_controller.validate_well_known_text(test_value)
      expect(result[:status]).to eq true
    end
  end

  describe "well_known_text_to_polygon" do
    it "throws an exception given invalid input" do
      test_value = 'INCORRECT((12345 345567, 234234 -56.788))'
      expect { ticket_data_controller.well_known_text_to_polygon(test_value) }.to raise_error(RuntimeError)
    end

    it "converts valid input to polygon data format" do

      # POLYGON((-81.13390268058475 32.07206917625161,-81.14660562247929 32.04064386441295,-81.08858407706913 32.02259853170128))
      # example output:
      # ( ( x1 , y1 ) , ... , ( xn , yn ) )
      test_value = 'POLYGON((56.23 -123.456,58.835 -123.987,55.2 -125.67))'
      expected_result = '((56.23,-123.456),(58.835,-123.987),(55.2,-125.67))'
      result = ticket_data_controller.well_known_text_to_polygon(test_value)
      expect(result).to eq expected_result
    end
  end

  describe "build_excavator_address" do
    it "builds excavator address string from json data" do
      test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address":"555 Some RD",
          "City":"SOME PARK",
          "State":"ZZ",
          "Zip":"55555"
        }
      }'
      test_json = JSON.parse(test_data)
      expected_result = '555 Some RD, SOME PARK, ZZ, 55555'
      result = ticket_data_controller.build_excavator_address(test_json)
      expect(result).to eq expected_result
    end
  end

end
