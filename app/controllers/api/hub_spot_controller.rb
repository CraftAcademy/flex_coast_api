class Api::HubSpotController < ApplicationController
  before_action :authenticate_user!

  def create
    inquiry = Inquiry.find(params[:inquiry_id])
    HubSpotService.send(inquiry)
    inquiry.notes.create(body: "This inquiry was exported to HubSpot", creator: current_user)
    render json: { message: 'Successfully added to HubSpot' }
  rescue => error
    if error.message == "409 Conflict"
      error_response = JSON.parse(error.response.body)
      render json: { error_message: error_response["errors"].first["message"] }, status:  error.http_code
    else
      render json: { error_message: error.message}, status:  422
    end
  end
end