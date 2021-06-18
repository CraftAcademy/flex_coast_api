RSpec.describe 'GET /api/inquiries', type: :request do
  let!(:started_inquiry) { create(:inquiry, broker: broker) }
  let!(:inquiry) { 2.times { create(:inquiry) } }
  let(:broker) { create(:user, email: 'broker@email.com') }

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

    it 'is expected to include the inquiry\'s status type' do
      expect(response_json['inquiries'].first['inquiry_status']).to eq 'pending'
    end

    it 'is expected to include the inquiry\'s peer request' do
      expect(response_json['inquiries'].first['peers']).to eq true
    end

    it 'is expected to include the inquiry\'s email' do
      expect(response_json['inquiries'].first['email']).to eq 'mrfake@fake.com'
    end

    it 'is expected to include the inquiry\'s flexibility preference' do
      expect(response_json['inquiries'].first['flexible']).to eq 'yes'
    end

    it 'is expected to include the inquiry\'s start date' do
      expect(response_json['inquiries'].first['start_date']).to eq 'now'
    end

    it 'is expected to include the inquiry\'s language preference' do
      expect(response_json['inquiries'].first['language']).to eq 'en'
    end

    it 'is expected to include the inquiry\'s phone number' do
      expect(response_json['inquiries'].first['phone']).to eq '0707123456'
    end

    it 'is expected to include the inquiry\'s created date' do
      expect(response_json['inquiries'].first['inquiry_date']).to eq Time.zone.now.strftime('%d %b %Y')
    end

    describe 'is expected to return inquiry notes' do
      it 'with their body' do
        expect(response_json['inquiries'].first['notes'].first).to include "body"
      end

      it 'with their creator' do
        expect(response_json['inquiries'].first['notes'].first).to include "creator"
      end

      it 'with their id' do
        expect(response_json['inquiries'].first['notes'].first).to include "id"
      end

      it 'with their date' do
        expect(response_json['inquiries'].first['notes'].first).to include "date"
      end
    end

    describe 'is expected to include broker details' do
      it 'with their name' do
        expect(response_json['inquiries'].last['broker']['email']).to eq 'broker@email.com'
      end

      it 'with their email' do
        expect(response_json['inquiries'].last['broker']['name']).to eq 'John Doe'
      end

      it 'with their id' do
        expect(response_json['inquiries'].last['broker']['id']).to eq broker.id
      end
    end
  end
end
