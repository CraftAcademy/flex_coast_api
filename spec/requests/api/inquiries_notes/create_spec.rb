RSpec.describe 'POST /api/inquiries/:id/notes', type: :request do
  let(:inquiry) { create(:inquiry, inquiry_status: 'pending') }
  let(:writer) { create(:user) }
  let(:credentials) { writer.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }


  describe 'successfully' do
    before do
      post "/api/inquiries/#{inquiry.id}/notes",
      params: {
        note: {
          body: 'Dont mention clients hairy nose'
        }
      },
      headers: headers
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a success message' do
      expect(response_json['message']).to eq 'Note successfully created'
    end

    it 'is expected to have note associated to user that submited it' do
      expect(inquiry.notes.last.writer).to eq writer
    end
  end

  # describe 'unsuccessfully' do
  #   before do
  #     post "/api/inquiries/#{inquiry.id}/notes"
  #   end
  # end
end 