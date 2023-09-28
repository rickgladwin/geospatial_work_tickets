# frozen_string_literal: true

describe Api::V1::TicketDataController do
  ticket_data_controller = Api::V1::TicketDataController.new

  describe 'Unit tests' do
    describe "validate_well_known_text" do
      it "invalidates well_known_text missing POLYGON prefix" do
        test_value = 'INCORRECT((12345 345567, 234234 -56.788))'
        result     = ticket_data_controller.validate_well_known_text(test_value)
        expect(result[:status]).to eq false
      end

      it "invalidates well_known_text with fewer than 3 polygon points" do
        test_value = 'POLYGON((58.835 -123.987,55.2 -125.67))'
        result     = ticket_data_controller.validate_well_known_text(test_value)
        expect(result[:status]).to eq false
      end

      it "invalidates well_known_text with extra leading spaces" do
        test_value = 'POLYGON(( 56.23 -123.456,58.835 -123.987,55.2 -125.67))'
        result     = ticket_data_controller.validate_well_known_text(test_value)
        expect(result[:status]).to eq false
      end

      it "invalidates well_known_text with extra trailing spaces" do
        test_value = 'POLYGON((56.23 -123.456,58.835 -123.987,55.2 -125.67 ))'
        result     = ticket_data_controller.validate_well_known_text(test_value)
        expect(result[:status]).to eq false
      end

      it "invalidates well_known_text with spaces after commas" do
        test_value = 'POLYGON((56.23 -123.456, 58.835 -123.987, 55.2 -125.67))'
        result     = ticket_data_controller.validate_well_known_text(test_value)
        expect(result[:status]).to eq false
      end

      it "validates well_known_text" do
        test_value = 'POLYGON((56.23 -123.456,58.835 -123.987,55.2 -125.67))'
        result     = ticket_data_controller.validate_well_known_text(test_value)
        expect(result[:status]).to eq true
      end
    end

    describe "well_known_text_to_polygon" do
      # NOTE: validation extracted (well_known_text_to_polygon expects valid data)
      # it "throws an exception given invalid input" do
      #   test_value = 'INCORRECT((12345 345567, 234234 -56.788))'
      #   expect { ticket_data_controller.well_known_text_to_polygon(test_value) }.to raise_error(RuntimeError)
      # end

      it "converts valid input to polygon data format" do
        # example input:
        # POLYGON((-81.13390268058475 32.07206917625161,-81.14660562247929 32.04064386441295,-81.08858407706913 32.02259853170128))
        # example output:
        # ( ( x1 , y1 ) , ... , ( xn , yn ) )
        test_value      = 'POLYGON((56.23 -123.456,58.835 -123.987,55.2 -125.67))'
        expected_result = '((56.23,-123.456),(58.835,-123.987),(55.2,-125.67))'
        result          = ticket_data_controller.well_known_text_to_polygon(test_value)
        expect(result).to eq expected_result
      end
    end

    describe "build_excavator_address" do
      it "builds excavator address string from json data" do
        test_data       = '{
        "SomeKey": "some value",
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address":"555 Some RD",
          "City":"SOME PARK",
          "State":"ZZ",
          "Zip":"55555"
        }
      }'
        test_json       = JSON.parse(test_data)
        expected_result = '555 Some RD, SOME PARK, ZZ, 55555'
        result          = ticket_data_controller.build_excavator_address(test_json)
        expect(result).to eq expected_result
      end
    end

    describe 'validate_excavator_address' do
      it 'invalidates input data missing Excavator' do
        test_data = '{
        "Something": "some value"
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end

      it 'invalidates input data where Excavator is not a key-value object' do
        test_data = '{
        "Something": "some value",
        "Excavator": "some value"
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end

      it 'invalidates input data missing Address' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "City":"SOME PARK",
          "State":"ZZ",
          "Zip":"55555"
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end

      it 'invalidates input data with blank Address' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address":"",
          "City":"SOME PARK",
          "State":"ZZ",
          "Zip":"55555"
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end
      it 'invalidates input data missing City' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address":"123 Something Rd",
          "State":"ZZ",
          "Zip":"55555"
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end

      it 'invalidates input data with blank City' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address":"123 Something Rd",
          "City":"",
          "State":"ZZ",
          "Zip":"55555"
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end
      it 'invalidates input data with missing State' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address": "123 Something St",
          "City":"SOME PARK",
          "Zip":"55555"
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end
      it 'invalidates input data with blank State' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address": "123 Something St",
          "City":"SOME PARK",
          "State":"",
          "Zip":"55555"
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end
      it 'invalidates input data with missing Zip' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address": "123 Something St",
          "City":"SOME PARK",
          "State":"ZZ"
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end
      it 'invalidates input data with blank Zip' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address": "123 Something St",
          "City":"SOME PARK",
          "State":"ZZ",
          "Zip":""
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq false
      end
      it 'validates input data' do
        test_data = '{
        "Excavator":{
          "CompanyName":"John Doe CONSTRUCTION",
          "Address": "123 Something St",
          "City":"SOME PARK",
          "State":"ZZ",
          "Zip":"55555"
        }
      }'
        test_json = JSON.parse(test_data)
        result    = ticket_data_controller.validate_excavator_address(test_json)
        expect(result[:status]).to eq true
      end
    end
  end

  describe 'API tests' do
    # TODO: build API tests for ticket data input endpoint
  end

end
