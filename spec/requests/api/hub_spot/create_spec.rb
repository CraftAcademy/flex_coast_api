RSpec.describe 'POST /api/inquiries/:id/hub_spot', type: :request do
  let(:broker) { create(:user, email: 'broker@flexcoast.com') }
  let(:credentials) { broker.create_new_auth_token }
  let(:broker_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:inquiry) { create(:inquiry, inquiry_status: 'started', email: 'steve@yahoo.se') }

  describe 'successfully' do
    before do
      post "/api/inquiries/#{inquiry.id}/hub_spot",
          params: {},
          headers: broker_headers
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a success message' do
      expect(response_json['message']).to eq 'Successfully added to HubSpot'
    end

    it 'is expected to send off HubSpot request for contact' do
      expect(a_request(:post, "https://api.hubapi.com/contacts/v1/contact?hapikey=#{Rails.application.credentials.dig(:hub_spot, :api_key)}")).to have_been_made.times(1)
    end

    it 'is expected to send off HubSpot request for note' do
      expect(a_request(:post, "https://api.hubapi.com/engagements/v1/engagements?hapikey=#{Rails.application.credentials.dig(:hub_spot, :api_key)}")).to have_been_made.times(1)
    end
  end
end