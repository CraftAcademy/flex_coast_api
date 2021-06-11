RSpec.describe 'POST /api/inquiries/:id/notes', type: :request do
  let(:inquiry) { create(:inquiry, inquiry_status: 'pending') }

  describe 'successfully' do
    before do
      post "/api/inquiries/#{inquiry.id}/notes"
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a success message' do
      expect(response_json['message']).to eq 'Note successfully created'
    end
  end

  # describe 'unsuccessfully' do
  #   before do
  #     post "/api/inquiries/#{inquiry.id}/notes"
  #   end
  # end
end 