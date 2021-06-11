class Api::NotesController < ApplicationController
  before_action :authenticate_user!

  def create
    inquiry = Inquiry.find(params[:inquiry_id])

    note = inquiry.notes.create(note_params.merge(writer: current_user))

    if note.persisted?
      render json: { message: 'Note successfully created' }
    else
      binding.pry
    end
  end

  private 

  def note_params
    params.require(:note).permit(:body)
  end
end