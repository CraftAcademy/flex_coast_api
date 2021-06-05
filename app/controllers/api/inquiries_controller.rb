class Api::InquiriesController < ApplicationController
  def create
    inquiry = Inquiry.create(params[:inquiry].permit(:size, :type, :company, :peers, :email, :date, :flexible, :phone))
    render json: { message: 'Thanks for your answers! We\'ll be in touch' }, status: 200
  end

  # private

  # def inquiry_params
  #   params.require(:inquiry).permit(:size, :type, :company, :peers, :email, :date, :flexible, :phone)
  # end
end
