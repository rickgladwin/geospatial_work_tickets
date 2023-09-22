# require_relative '../../application_controller'
# require_relative '../'
class Api::V1::TicketDataController < ApplicationController
  # disable CSRF protection (use API token in production)
  protect_from_forgery with: :null_session

  def input
    # render inline: "API endpoint"
    # parse input json
    input_json = JSON.parse(request.raw_post)
    # render inline: request.raw_post
    # render inline: input_json
    # render inline: input_json['ContactCenter']
    render inline: input_json['ExcavationInfo']['DigsiteInfo']['WellKnownText']

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
    # digsite_info: input_json['DigsiteInfo']['WellKnownText'],
    )
    # new_ticket = Ticket.create(
    #   request_number: input_json['RequestNumber'],
    #   sequence_number: input_json['SequenceNumber'],
    #   request_type: input_json['Normal'],
    #   request_action: input_json['Restake'],
    #   response_due_date_time: input_json['DateTimes']['ResponseDueDateTime'],
    #   primary_service_area_code: input_json['ServiceArea']['PrimaryServiceAreaCode']['SACode'],
    #   additional_service_area_codes: input_json['ServiceArea']['AdditionalServiceAreaCodes']['SACode'],
    # # digsite_info: input_json['DigsiteInfo']['WellKnownText'],
    #   )
    # render inline: "created new ticket: #{new_ticket.request_number}"
  end

  # converts value format from json data to PostgreSQL polygon format
  # example input:
  # POLYGON((-81.13390268058475 32.07206917625161,-81.14660562247929 32.04064386441295,-81.08858407706913 32.02259853170128))
  def well_known_text_to_polygon(well_known_text)
    # guard format
    input_regex = /POLYGON\(\(.*\)\)/

  end

  def validate_well_known_text(well_known_text)
    value_regex = /POLYGON\(\((-?\d{1,2}(\.\d+)? -?\d{1,3}(\.\d+)?)(,-?\d{1,2}(\.\d+)? -?\d{1,3}(\.\d+)?){2,}\)\)/
    if value_regex.match(well_known_text)
      return { :status => true, :message => '' }
    else
      return { :status => false, :message => "well_known_text value does not match regex pattern #{value_regex}"}
    end
    return { :status => false, :message => 'could not validate well_known_text'}
  end
end

if __FILE__ == $0
  require_relative '../../../../config/global_config'
  exit unless Config.run_file_level_unit_tests

  require_relative '../../application_controller'
  test_ticket_data_controller = Api::V1::TicketDataController.new

  # file-level unit tests
  # These are development artifacts left in place as debugging/refactoring tools
  # or deleted in production code. These tests are more minimal and informal than
  # RSpec tests.

  # invalidates well_known_text in the wrong format
  test_value               = 'INCORRECT((12345 345567, 234234 -56.788))'
  expected_validation_bool = false
  raise "failed to invalidate well_known_text" unless test_ticket_data_controller.validate_well_known_text(test_value)[0] == expected_validation_bool

  puts "file level unit tests passed"
end