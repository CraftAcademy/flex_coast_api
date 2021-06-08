class Api::InquiriesController < ApplicationController
  def create
    inquiry = Inquiry.create(inquiry_params)

    if inquiry.persisted?
      InquiryMailer.created_email(inquiry).deliver
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
    render json: { inquiry: inquiry, message: 'Inquiry has been updated' }, status: 200
  rescue ArgumentError => e
    render json: { message: e.message }, status: 422
  end

  private

  def inquiry_params
    params.require(:form_data).permit(:size, :office_type, :inquiry_status, :company, :start_date, :peers, :email, :flexible,
                                      :phone, locations: [])
  end
end
