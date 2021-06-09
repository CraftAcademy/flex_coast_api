RSpec.describe 'PUT /api/inquiries/:id', type: :request do
  let(:inquiry) { create(:inquiry, inquiry_status: 'pending') }
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:user_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:invalid_auth_header) { { HTTP_ACCEPT: 'application/json' } }

  describe 'successfully updated' do
    before do
      put "/api/inquiries/#{inquiry.id}",
          params: {
            form_data: { inquiry_status: 'started' }
          },
          headers: user_headers
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to be associated to user that updated inquiry status' do
      inquiry.reload
      expect(inquiry.broker).to eq user
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'Inquiry has been updated'
    end

    it 'is expected to set inquiry status to started' do
      expect(response_json['inquiry']['inquiry_status']).to eq 'started'
    end
  end

  describe 'unsuccessfully updated with wrong params' do
    before do
      put "/api/inquiries/#{inquiry.id}",
          params: {
            form_data: { inquiry_status: 'Your mom' }
          },
          headers: user_headers
    end

    it 'is expected to return a 422 status' do
      expect(response).to have_http_status 422
    end

    it 'is expected to return error message' do
      expect(response_json['message'])
        .to eq "'Your mom' is not a valid inquiry_status"
    end
  end

  describe 'unsuccessfully without valid authentication' do
    before do
      put "/api/inquiries/#{inquiry.id}",
          params: {
            form_data: { inquiry_status: 'started' }
          },
          headers: invalid_auth_header
    end

    it 'is expected to return a 401 status' do
      expect(response).to have_http_status 401
    end

    it 'is expected to return error message' do
      expect(response_json['errors'])
        .to include "You need to sign in or sign up before continuing."
    end
  end
end
