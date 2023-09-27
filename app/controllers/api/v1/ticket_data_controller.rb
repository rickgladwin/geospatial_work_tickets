# Handles incoming ticket data

class Api::V1::TicketDataController < ApplicationController
  # disable CSRF protection (use API token in production)
  protect_from_forgery with: :null_session

  def input
    # parse input json
    input_json = JSON.parse(request.raw_post)
    # render inline: input_json['ExcavationInfo']['DigsiteInfo']['WellKnownText']

    # validate input data
    # create Ticket and Excavator from input data
    new_ticket = Ticket.create(
      request_number:                input_json['RequestNumber'],
      sequence_number:               input_json['SequenceNumber'],
      request_type:                  input_json['RequestType'],
      request_action:                input_json['RequestAction'],
      response_due_date_time:        input_json['DateTimes']['ResponseDueDateTime'],
      primary_service_area_code:     input_json['ServiceArea']['PrimaryServiceAreaCode']['SACode'],
      additional_service_area_codes: input_json['ServiceArea']['AdditionalServiceAreaCodes']['SACode'],
      digsite_info: well_known_text_to_polygon(input_json['ExcavationInfo']['DigsiteInfo']['WellKnownText']),
    )
    # render inline: "new Ticket created: #{new_ticket.to_json}", status: 201

    new_excavator = Excavator.create(
      company_name: input_json['Excavator']['CompanyName'],
      address: build_excavator_address(input_json),
      crew_on_site: input_json['Excavator']['CrewOnsite'],
      ticket_id: new_ticket.id
    )

    render inline: "new Ticket and Excavator created: #{new_ticket.to_json}, #{new_excavator.to_json}", status: 201
  end

  # converts value format from json data to PostgreSQL polygon format
  # example input:
  # POLYGON((-81.13390268058475 32.07206917625161,-81.14660562247929 32.04064386441295,-81.08858407706913 32.02259853170128))
  # example output:
  # ( ( x1 , y1 ) , ... , ( xn , yn ) )
  def well_known_text_to_polygon(well_known_text)
    # validate format
    validation_result = validate_well_known_text(well_known_text)
    if validation_result[:status] == false
      raise "well_known_text validation for #{well_known_text} failed: #{validation_result[:message]}"
    end

    coordinates = '('

    # parse value
    well_known_text_array = well_known_text
                              .delete_prefix('POLYGON((')
                              .delete_suffix('))')
                              .split(',')
    well_known_text_array.each do |lat_long_string|
      lat_long = lat_long_string.split(' ')
      coordinates += "(#{lat_long[0]},#{lat_long[1]}),"
    end
    coordinates.delete_suffix!(',')
    coordinates + ')'
  end

  def validate_well_known_text(well_known_text)
    value_regex = /POLYGON\(\((-?\d{1,2}(\.\d+)? -?\d{1,3}(\.\d+)?)(,-?\d{1,2}(\.\d+)? -?\d{1,3}(\.\d+)?){2,}\)\)/
    if value_regex.match(well_known_text)
      { :status => true, :message => '' }
    else
      { :status => false, :message => "well_known_text value does not match regex pattern (minimum 3 lat/long pairs, no padding spaces) #{value_regex}"}
    end
  end

  def build_excavator_address(input_json)
    "#{input_json['Excavator']['Address']}, "+
      "#{input_json['Excavator']['City']}, "+
      "#{input_json['Excavator']['State']}, "+
      "#{input_json['Excavator']['Zip']}"
  end
end
