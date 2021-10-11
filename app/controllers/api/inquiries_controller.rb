class Api::InquiriesController < ApplicationController
  before_action :authenticate_user!, only: :update
  before_action :cast_boolean, only: [:create]
  rescue_from StandardError, with: :rescue_from_standard_error

  def create
    if @office_provider_inquiry
      HubSpotService.send(params[:inquiry])
      render json: { message: 'Thanks for your answers! We\'ll be in touch' } and return
    else
      inquiry = Inquiry.create(inquiry_params)
    end
    if inquiry.persisted?
      render json: { message: 'Thanks for your answers! We\'ll be in touch' }
    else
      render json: { error_message: 'Unfortunately, we had a small issue processing your request. Would you please try again?' },
             status: 422
    end
  end

  def index
    inquiries = Inquiry.order(created_at: :desc).all
    render json: inquiries, each_serializer: Inquiries::IndexSerializer
  end

  def update
    inquiry = Inquiry.find(params[:id])
    if inquiry.pending?
      inquiry.update(
        broker: current_user
      )
    else
      authorize_resource(inquiry) and return
    end
    inquiry.send(params[:inquiry][:status_action])
    inquiry.save
    render json: {
      inquiry: inquiry,
      message: 'Inquiry has been updated'
    }, status: 200
  rescue NoMethodError
    render json: { message: 'Invalid status action' }, status: 422
  end

  private

  def cast_boolean
    if params[:inquiry][:officeProvider] 
      @office_provider_inquiry = ActiveModel::Type::Boolean.new.cast(params[:inquiry][:officeProvider])
    end
  end

  def authorize_resource(inquiry)
    render json: { message: 'You are not authorized to do this' }, status: 422 unless authorized?(inquiry, :update?)
  end

  def inquiry_params
    params.require(:inquiry).permit(:size, :office_type, :inquiry_status, :peers, :email, :flexible,
                                      :phone, :start_date, :language, locations: [])
  end

  def rescue_from_standard_error(error)
    render json: { message: error.message }, status: 422
  end
end
