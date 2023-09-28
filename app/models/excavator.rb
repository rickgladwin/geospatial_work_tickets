class Excavator < ApplicationRecord
  validates :company_name, :address, :crew_on_site, :ticket_id, presence: true

  belongs_to :ticket
end
