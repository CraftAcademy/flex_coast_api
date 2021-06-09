class Api::InquiriesController < ApplicationController
  before_action :authenticate_user!, only: :update
  def create
    inquiry = Inquiry.create(inquiry_params)

    if inquiry.persisted?
      render json: { message: 'Thanks for your answers! We\'ll be in touch' }
    else
      render json: { error_message: 'Unfortunately, we had a small issue processing your request. Would you please try again?' },
             status: 422
    end
  end

  def index
    inquiries = Inquiry.all
    render json: inquiries, each_serializer: InquiriesIndexSerializer
  end

  def update
    inquiry = Inquiry.find(params[:id])
    if inquiry.pending?
      inquiry.update(
        inquiry_status: params[:form_data][:inquiry_status],
        broker: current_user
      )
    else
      authorize_resource(inquiry) and return

      inquiry.update(
        inquiry_status: params[:form_data][:inquiry_status]
      )
    end

    render json: {
      inquiry: inquiry,
      message: 'Inquiry has been updated'
    }, status: 200
  rescue ArgumentError => e
    render json: { message: e.message }, status: 422
  end

  private

  def authorize_resource(inquiry)
    render json: { message: 'You are not authorized to do this' },  status: 422 unless authorized?(inquiry, :update?)
  end

  def inquiry_params
    params.require(:form_data).permit(:size, :office_type, :inquiry_status, :company, :start_date, :peers, :email, :flexible,
                                      :phone, locations: [])
  end
end
