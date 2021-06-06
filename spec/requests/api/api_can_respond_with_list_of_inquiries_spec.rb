RSpec.describe 'GET /api/inquiries', type: :request do
  let!(:inquiry) {3.times{create(:inquiry)}}
  describe 'successfully' do
    before do
      get '/api/inquiries'
    end

    it 'is expected to respond with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a list of 3 inquiries' do
      expect(response_json['inquiries'].count).to eq 3
    end

    it 'is expected to include the inquiry\'s company size' do
      expect(response_json['inquiries'].first['size']).to eq 5 
    end

    it 'is expected to include the inquiry\'s office type' do
      expect(response_json['inquiries'].first['office_type']).to eq 'office' 
    end

    it 'is expected to include the inquiry\'s company name' do
      expect(response_json['inquiries'].first['company']).to eq 'Company'
    end

    it 'is expected to include the inquiry\'s peer request' do
      expect(response_json['inquiries'].first['peers']).to eq true 
    end

    it 'is expected to include the inquiry\'s email' do
      expect(response_json['inquiries'].first['email']).to eq 'mrfake@fake.com' 
    end

    it 'is expected to include the inquiry\'s peer request' do
      expect(response_json['inquiries'].first['flexible']).to eq true 
    end

    it 'is expected to include the inquiry\'s start date' do
      expect(response_json['inquiries'].first['start_date']).to eq '2021-06-16' 
    end

    it 'is expected to include the inquiry\'s phone number' do
      expect(response_json['inquiries'].first['phone']).to eq 0707123456 
    end
  end
end
