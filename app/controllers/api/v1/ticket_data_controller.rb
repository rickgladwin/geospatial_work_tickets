class Api::V1::TicketDataController < ApplicationController
  # disable CSRF protection
  protect_from_forgery with: :null_session
  def input
    # render inline: "API endpoint"
    render inline: request.raw_post
  end
end
