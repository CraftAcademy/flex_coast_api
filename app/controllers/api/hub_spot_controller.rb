class Api::HubSpotController < ApplicationController
  before_action :authenticate_user!

  def create
    inquiry = Inquiry.find(params[:inquiry_id])

    HubSpotService.move(inquiry)
    render json: { message: 'Successfully added to HubSpot' }
  rescue => error
    binding.pry
    render json: { error_message: error.message }
  end
end