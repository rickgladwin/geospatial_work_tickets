class Ticket < ApplicationRecord
  validates :request_number, :sequence_number, :request_type, :request_action, :primary_service_area_code, presence: true
  validate :response_due_date_time_format

  has_one :excavator

private

  def response_due_date_time_format
    # ensure input string can be converted to datetime
    begin
      response_due_date_time.to_datetime
    rescue NoMethodError
      errors.add(:response_due_date_time, "must be a date-formatted string (YYYY/MM/DD HH:mm:ss).")
    rescue Date::Error => e
      errors.add(:response_due_date_time, "cannot convert input data to datetime. Format should be: 'YYYY/MM/DD HH:mm:ss'. #{e} ")
    end
  end
end
