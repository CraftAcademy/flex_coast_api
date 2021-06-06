RSpec.describe 'POST /api/inquiries', type: :request do
  describe 'successfully' do
    before do
      post '/api/inquiries',
           params: {
             form_data: {
               size: 1,
               variants: 'office',
               company: 'Craft',
               peers: true,
               email: 'example@example.com',
               date: '2021-06-05',
               flexible: true,
               phone: 0o707123456,
               locations: ['Gothenburg City', 'Southside'],
               start_date: '21-06-21'
             }
           }
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a success message' do
      expect(response_json['message']).to eq 'Thanks for your answers! We\'ll be in touch'
    end

    it 'is expected to have created a new Inquiry' do
      expect(Inquiry.all.count).to eq 1
    end
  end

  describe 'unsuccessfully without required params' do
    before do
      post '/api/inquiries',
           params: {
             form_data: {
               size: 1,
               variants: 'office',
               company: 'Craft',
               peers: true,
               email: '',
               flexible: true,
               phone: 0o707123456,
               locations: ['Gothenburg City', 'Southside'],
               start_date: '21-06-21'
             }
           }
    end

    it 'is expected to return a 422 status' do
      expect(response).to have_http_status 422
    end

    it 'is expected to respond with a success message' do
      expect(response_json['error_message']).to eq 'Unfortunately, we had a small issue processing your request. Would you please try again?'
    end
  end
end
