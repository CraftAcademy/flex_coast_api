RSpec.describe 'POST /api/inquiries', type: :request do
  describe 'successfully' do
    before do
      post '/api/inquiries'
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a success message' do
      expect(response_json['message']).to eq 'Thanks for your answers! We\'ll be in touch'
    end
  end
end
