class Api::NotesController < ApplicationController
  before_action :authenticate_user!

  def create
    inquiry = Inquiry.find(params[:inquiry_id])

    note = inquiry.notes.create(note_params.merge(creator: current_user))

    if note.persisted?
      render json: { message: 'Note successfully created' }
    else
      render json: { error_message: 'Unfortunately, we had a small issue processing your request. Would you please try again?' },
              status: 422
    end  
  rescue => error
    render json: { error_message: error.message }, status: 422
  end

  private 

  def note_params
    params.require(:note).permit(:body)
  end
end