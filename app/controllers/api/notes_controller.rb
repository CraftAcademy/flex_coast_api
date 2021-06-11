class Api::NotesController < ApplicationController
  before_action :authenticate_user!

  def create
    inquiry = Inquiry.find(params[:inquiry_id])

    note = current_user.notes.create(note_params).merge(inquiry: inquiry)

    if note.persisted?
      render json: { message: 'Note successfully created' }
    else
      binding.pry
    end
  end
end