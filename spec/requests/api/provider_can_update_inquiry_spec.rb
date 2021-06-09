RSpec.describe 'PUT /api/inquiries/:id', type: :request do
  let(:broker_1) { create(:user, email: 'broker@flexcoast.com') }
  let(:credentials) { broker_1.create_new_auth_token }
  let(:broker_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:pending_inquiry) { create(:inquiry, inquiry_status: 'pending') }
  
  describe 'successfully' do
    describe 'from pending to started' do

      before do
        put "/api/inquiries/#{pending_inquiry.id}",
            params: {
              form_data: { inquiry_status: 'started' }
            },
            headers: broker_headers
      end
  
      it 'is expected to return a 200 status' do
        expect(response).to have_http_status 200
      end
  
      it 'is expected to be associated to user that updated inquiry status' do
        pending_inquiry.reload
        expect(pending_inquiry.broker).to eq broker_1
      end
  
      it 'is expected to respond with a message' do
        expect(response_json['message']).to eq 'Inquiry has been updated'
      end
  
      it 'is expected to set inquiry status to started' do
        expect(response_json['inquiry']['inquiry_status']).to eq 'started'
      end  
    end

    describe 'from started to done' do
      let(:started_inquiry) { create(:inquiry, inquiry_status: 'started', broker: broker_1) }

      before do
        put "/api/inquiries/#{started_inquiry.id}",
            params: {
              form_data: { inquiry_status: 'done' }
            },
            headers: broker_headers
      end
  
      it 'is expected to return a 200 status' do
        expect(response).to have_http_status 200
      end
  
      it 'is expected to respond with a message' do
        expect(response_json['message']).to eq 'Inquiry has been updated'
      end
  
      it 'is expected to set inquiry status to done' do
        expect(response_json['inquiry']['inquiry_status']).to eq 'done'
      end
    end
  end

  describe 'unsuccessfull' do
    describe 'with invalid params' do
      before do
        put "/api/inquiries/#{pending_inquiry.id}",
            params: {
              form_data: { inquiry_status: 'Your mom' }
            },
            headers: broker_headers
      end
  
      it 'is expected to return a 422 status' do
        expect(response).to have_http_status 422
      end
  
      it 'is expected to return error message' do
        expect(response_json['message'])
          .to eq "'Your mom' is not a valid inquiry_status"
      end
    end

    describe 'without valid authentication' do
      let(:invalid_auth_header) { { HTTP_ACCEPT: 'application/json' } }

      before do
        put "/api/inquiries/#{pending_inquiry.id}",
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

    describe 'as another broker' do
      let(:started_inquiry) { create(:inquiry, inquiry_status: 'started', broker: broker_1) }
      let(:broker_2) { create(:user, email: 'another_broker@flexcoast.com') }
      let(:credentials) { broker_2.create_new_auth_token }
      let(:broker_2_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
    
      before do
        put "/api/inquiries/#{started_inquiry.id}",
            params: {
              form_data: { inquiry_status: 'done' }
            },
            headers: broker_2_headers
      end

      it 'is expected to return 422 status' do
        expect(response).to have_http_status 422
      end
    
      it 'is expected to return error message' do
        expect(response_json['message'])
          .to eq "You are not authorized to do this"
      end
    end
  end
end
