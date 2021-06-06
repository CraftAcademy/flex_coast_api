class Api::InquiriesController < ApplicationController
  def create
    inquiry = Inquiry.create(inquiry_params)

    if inquiry.persisted? 
      render json: { message: 'Thanks for your answers! We\'ll be in touch' }, status: 200
    else 
      render json: { error_message: 'Unfortunately, we had a small issue processing your request. Would you please try again?' }, status: 422
    end
  end

  private

  def inquiry_params
    params.require(:form_data).permit(:size, :office_type, :company, :peers, :email, :flexible, :phone, locations: [])
  end
end
