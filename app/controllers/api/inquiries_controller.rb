class Api::InquiriesController < ApplicationController
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
    inquiry.update(inquiry_status: params[:form_data][:inquiry_status])
    if params[:inquiry_status]
      render json: { inquiry: inquiry, message: 'Inquiry has been updated' }, status: 200
    else
      render json: { message: 'Inquiry has not been updated' }, status: 422
    end
  end

  private

  def inquiry_params
    params.require(:form_data).permit(:size, :office_type, :inquiry_status, :company, :peers, :email, :flexible,
                                      :phone, locations: [])
  end
end
