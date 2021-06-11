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
              inquiry: { status_action: 'start' }
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

      it 'is expected to create associated note about when inquiry was started' do
        pending_inquiry.reload
        expect(pending_inquiry.notes.last.body).to eq "When the inquiry status was updated from pending to started"
      end
    end

    describe 'from started to done' do
      let(:started_inquiry) { create(:inquiry, inquiry_status: 'started', broker: broker_1) }

      before do
        put "/api/inquiries/#{started_inquiry.id}",
            params: {
              inquiry: { status_action: 'finish' }
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

      it 'is expected to create associated note about when inquiry was finished' do
        pending_inquiry.reload
        expect(pending_inquiry.notes.last.body).to eq "When the inquiry status was updated from started to done"
      end
    end

    describe 'from started to pending' do
      let(:started_inquiry) { create(:inquiry, inquiry_status: 'started', broker: broker_1) }

      before do
        put "/api/inquiries/#{started_inquiry.id}",
            params: {
              inquiry: { status_action: 'set_to_pending' }
            },
            headers: broker_headers
      end

      it 'is expected to return a 200 status' do
        expect(response).to have_http_status 200
      end

      it 'is expected to respond with a message' do
        expect(response_json['message']).to eq 'Inquiry has been updated'
      end

      it 'is expected to set inquiry status to pending' do
        expect(response_json['inquiry']['inquiry_status']).to eq 'pending'
      end

      it 'is expected to create associated note about when inquiry was set tp pending' do
        pending_inquiry.reload
        expect(pending_inquiry.notes.last.body).to eq "When the inquiry status was updated from started to pending"
      end
    end

  end

  describe 'unsuccessfull' do
    describe 'from "done" to "pending"' do
      let(:done_inquiry) { create(:inquiry, inquiry_status: 'done', broker: broker_1) }

      before do
        put "/api/inquiries/#{done_inquiry.id}",
            params: {
              inquiry: { status_action: 'set_to_pending' }
            },
            headers: broker_headers
      end

      it 'is expected to return a 422 status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return error message' do
        expect(response_json['message'])
          .to eq "You can't perform this on an inquiry that is 'done'"
      end
    end

    describe 'from "done" to "started"' do
      let(:done_inquiry) { create(:inquiry, inquiry_status: 'done', broker: broker_1) }

      before do
        put "/api/inquiries/#{done_inquiry.id}",
            params: {
              inquiry: { status_action: 'start' }
            },
            headers: broker_headers
      end

      it 'is expected to return a 422 status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return error message' do
        expect(response_json['message'])
          .to eq "You can't perform this on an inquiry that is 'done'"
      end
    end

    describe 'from "pending" to "done"' do
      before do
        put "/api/inquiries/#{pending_inquiry.id}",
            params: {
              inquiry: { status_action: 'finish' }
            },
            headers: broker_headers
      end

      it 'is expected to return a 422 status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return error message' do
        expect(response_json['message'])
          .to eq "You can't perform this on an inquiry that is 'pending'"
      end
    end

    describe 'with invalid params' do
      before do
        put "/api/inquiries/#{pending_inquiry.id}",
            params: {
              inquiry: { status_action: 'Your mom' }
            },
            headers: broker_headers
      end

      it 'is expected to return a 422 status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return error message' do
        expect(response_json['message'])
          .to eq "Invalid status action"
      end
    end

    describe 'without valid authentication' do
      let(:invalid_auth_header) { { HTTP_ACCEPT: 'application/json' } }

      before do
        put "/api/inquiries/#{pending_inquiry.id}",
            params: {
              inquiry: { status_action: 'start' }
            },
            headers: invalid_auth_header
      end

      it 'is expected to return a 401 status' do
        expect(response).to have_http_status 401
      end

      it 'is expected to return error message' do
        expect(response_json['errors'])
          .to include 'You need to sign in or sign up before continuing.'
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
              inquiry: { status_action: 'finish' }
            },
            headers: broker_2_headers
      end

      it 'is expected to return 422 status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return error message' do
        expect(response_json['message'])
          .to eq 'You are not authorized to do this'
      end
    end
  end
end