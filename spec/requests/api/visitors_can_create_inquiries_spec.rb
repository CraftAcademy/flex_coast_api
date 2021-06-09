RSpec.describe 'POST /api/inquiries', type: :request do
  describe 'successfully' do
    let(:mail_delivery) { ActionMailer::Base.deliveries }

    before do
      post '/api/inquiries',
           params: {
             form_data: {
               size: 1,
               office_type: 'office',
               inquiry_status: 'pending',
               company: 'Craft',
               peers: true,
               email: 'example@example.com',
               flexible: true,
               phone: 0707123456,
               locations: ['Gothenburg City', 'Southside'],
               start_date: '2021-06-21'
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

    it 'is expected to send off slack notification' do
      expect(a_request(:post, Rails.application.credentials.dig(:slack, :webhook_url))).to have_been_made.times(1)
    end

    describe 'outgoing email' do
      it 'is expected to send off email address of the sender' do
        expect(mail_delivery[0].from).to include('notification@flexcoast.com')
      end

      it 'is expedted to return details of inquiry in subject' do
        expect(mail_delivery[0].subject).to include('New inquiry, 2021-06-21')
      end

      describe 'is expected to have inquiry detals in the body regarding' do
        it 'size' do
          expect(mail_delivery[0].body).to include('1')
        end

        it 'office type' do
          expect(mail_delivery[0].body).to include('office')
        end

        it 'company' do
          expect(mail_delivery[0].body).to include('Craft')
        end

        it 'peers' do
          expect(mail_delivery[0].body).to include('true')
        end

        it 'email' do
          expect(mail_delivery[0].body).to include('example@example.com')
        end

        it 'flexible' do
          expect(mail_delivery[0].body).to include('true')
        end

        it 'phone' do
          expect(mail_delivery[0].body).to include(0707123456)
        end

        it 'location' do
          expect(mail_delivery[0].body).to include('Gothenburg City', 'Southside')
        end

        it 'start date' do
          expect(mail_delivery[0].body).to include('2021-06-21')
        end
      end
    end
  end

  describe 'unsuccessfully without required params' do
    before do
      post '/api/inquiries',
           params: {
             form_data: {
               size: 1,
               office_type: 'office',
               inquiry_status: 'pending',
               company: 'Craft',
               peers: true,
               email: '',
               flexible: true,
               phone: 0707123456,
               locations: ['Gothenburg City', 'Southside'],
               start_date: '2021-06-21'
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
