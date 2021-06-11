RSpec.describe 'POST /api/inquiries/:id/notes', type: :request do
  let(:inquiry) { create(:inquiry, inquiry_status: 'pending') }
  let(:creator) { create(:user) }
  let(:credentials) { creator.create_new_auth_token }
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
      expect(inquiry.notes.last.creator).to eq creator
    end
  end

  describe 'unsuccessfull' do
    describe 'without valid authentication' do
      before do
        post "/api/inquiries/#{inquiry.id}/notes",
        params: {
          note: {
            body: 'Dont mention clients hairy nose'
          }
        }
      end

      it 'is expected to return a 401 status' do
        expect(response).to have_http_status 401
      end

      it 'is expected to return error message' do
        expect(response_json['errors'])
          .to include 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'with invalid param' do
      before do
        post "/api/inquiries/#{inquiry.id}/notes",
        params: {
          note: {
            body: ''
          }
        },
        headers: headers
      end

      it 'is expected to return a 422 status' do
        expect(response).to have_http_status 422
      end
  
      it 'is expected to return error message' do
        expect(response_json['error_message']).to eq 'Unfortunately, we had a small issue processing your request. Would you please try again?'
      end  
    end

    describe 'with wrong inquiry id' do
      before do
        post "/api/inquiries/420/notes",
        params: {
          note: {
            body: 'Fake inquiry id in request'
          }
        },
        headers: headers
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