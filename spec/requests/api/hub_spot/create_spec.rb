RSpec.describe 'POST /api/inquiries/:id/hub_spot', type: :request do
  let(:broker) { create(:user, email: 'broker@flexcoast.com') }
  let(:credentials) { broker.create_new_auth_token }
  let(:broker_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:inquiry) { create(:inquiry, inquiry_status: 'started', email: 'steve@yahoo.se') }

  describe 'successfully' do
    before do
      stub_request(
        :post, 
        "https://api.hubapi.com/contacts/v1/contact?hapikey=#{Rails.application.credentials.dig(:hub_spot, :api_key)}"
      ).to_return(
        status: 200, 
        body: file_fixture("contact_hub_spot_response.json").read
      )
  
      stub_request(
        :post, 
        "https://api.hubapi.com/engagements/v1/engagements?hapikey=#{Rails.application.credentials.dig(:hub_spot, :api_key)}"
      ).to_return(
        status: 200, 
        body: file_fixture("note_hub_spot_response.json").read
      )
  
      post "/api/inquiries/#{inquiry.id}/hub_spot",
        headers: broker_headers
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a success message' do
      expect(response_json['message']).to eq 'Successfully added to HubSpot'
    end

    it 'is expected to create note associated to inquiry about HubSpot export' do
      inquiry.reload
      expect(inquiry.notes.last.body).to eq 'This inquiry was exported to HubSpot'
    end

    it 'is expected to send off HubSpot request for contact' do
      expect(a_request(
        :post, 
        "https://api.hubapi.com/contacts/v1/contact?hapikey=#{Rails.application.credentials.dig(:hub_spot, :api_key)}"
      )).to have_been_made.times(1)
    end

    it 'is expected to send off HubSpot request for note' do
      expect(a_request(
        :post, 
        "https://api.hubapi.com/engagements/v1/engagements?hapikey=#{Rails.application.credentials.dig(:hub_spot, :api_key)}"
      )).to have_been_made.times(1)
    end
  end

  describe 'unsuccessfull' do
    describe 'when contact for email has already been made' do
      before do
        stub_request(
          :post, 
          "https://api.hubapi.com/contacts/v1/contact?hapikey=#{Rails.application.credentials.dig(:hub_spot, :api_key)}"
        ).to_return(
          status: 409, 
          body: file_fixture("error_hub_spot_response.json").read
        )

        post "/api/inquiries/#{inquiry.id}/hub_spot",
          headers: broker_headers
      end

      it 'is expected to return a 409 status' do
        expect(response).to have_http_status 409
      end

      it 'is expected to return error message' do
        expect(response_json['error_message'])
          .to eq 'A contact with email steve@yahoo.se already exists.'
      end
    end

    describe 'with invalid param' do
      before do
        post "/api/inquiries/420/hub_spot",
        headers: broker_headers
      end

      it 'is expected to return a 422 status' do
        expect(response).to have_http_status 422
      end
  
      it 'is expected to return error message' do
        expect(response_json['error_message']).to eq "Couldn't find Inquiry with 'id'=420"
      end  
    end
  end
end