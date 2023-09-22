# frozen_string_literal: true

describe Api::V1::TicketDataController, "#validate_well_known_text" do
  ticket_data_controller = Api::V1::TicketDataController.new

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

  it "validates well_known_text" do
    test_value = 'POLYGON((56.23 -123.456,58.835 -123.987,55.2 -125.67))'
    result = ticket_data_controller.validate_well_known_text(test_value)
    expect(result[:status]).to eq true
  end
end
