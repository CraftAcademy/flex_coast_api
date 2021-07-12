RSpec.describe 'POST /api/inquiries', type: :request do
  describe 'regular inquiry' do
    describe 'successfully' do
      let(:mail_delivery) { ActionMailer::Base.deliveries }

      before do
        post '/api/inquiries',
             params: {
               inquiry: {
                 size: 1,
                 office_type: 'office',
                 inquiry_status: 'pending',
                 peers: 'Yes',
                 email: 'example@example.com',
                 flexible: 'yes',
                 start_date: 'now',
                 phone: '0707123456',
                 locations: ['Gothenburg City', 'Southside'],
                 language: 'en'
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

      it 'is expected to create note associated to inquiry about when it got submited' do
        expect(Inquiry.last.notes.last.body).to eq 'This inquiry was submitted.'
      end

      describe 'outgoing email to broker' do
        it 'is expected to send off email address of the sender' do
          expect(mail_delivery[0].from).to include('notification@flexcoast.com')
        end

        it 'is expected to return details of inquiry in subject' do
          expect(mail_delivery[0].subject).to include("New inquiry, #{Inquiry.last.created_at.strftime('%d %b %Y')}")
        end

        describe 'is expected to have inquiry detals in the body regarding' do
          it 'size' do
            expect(mail_delivery[0].body).to include('1')
          end

          it 'office type' do
            expect(mail_delivery[0].body).to include('office')
          end

          it 'peers' do
            expect(mail_delivery[0].body).to include('Yes')
          end

          it 'email' do
            expect(mail_delivery[0].body).to include('example@example.com')
          end

          it 'flexible' do
            expect(mail_delivery[0].body).to include('yes')
          end

          it 'start date' do
            expect(mail_delivery[0].body).to include('now')
          end

          it 'phone' do
            expect(mail_delivery[0].body).to include('0707123456')
          end

          it 'location' do
            expect(mail_delivery[0].body).to include('Gothenburg City', 'Southside')
          end
        end
      end

      describe 'outgoing email to person that submitted inquiry' do
        it 'is expected to send email to the inquiry submitter' do
          expect(mail_delivery[1].to.first).to eq 'example@example.com'
        end

        it 'is expected to return details of inquiry in the subject' do
          expect(mail_delivery[1].subject).to include('FlexCost is on top of things!')
        end

        it 'is expected to contain welcome message in body' do
          expect(mail_delivery[1].body).to include('We received your inquiry and we have you covered! Our team will select the best offices for you, expect to hear from us withing a day or two.')
        end
      end
    end

    describe 'unsuccessfully without required params' do
      before do
        post '/api/inquiries',
             params: {
               inquiry: {
                 size: 1,
                 office_type: 'office',
                 inquiry_status: 'pending',
                 company: 'Craft',
                 peers: 'Yes',
                 email: '',
                 flexible: 'yes',
                 start_date: 'now',
                 phone: '0707123456',
                 locations: ['Gothenburg City', 'Southside']
               }
             }
      end

      it 'is expected to return a 422 status' do
        expect(response).to have_http_status 422
      end

      it 'is expected to return error message' do
        expect(response_json['error_message']).to eq 'Unfortunately, we had a small issue processing your request. Would you please try again?'
      end
    end
  end

  describe 'rent out office inquiry' do
    let(:mail_delivery) { ActionMailer::Base.deliveries }
    before do
      post '/api/inquiries',
           params: {
             inquiry: {
               officeProvider: true,
               name: 'Thomas',
               phone: '031111111',
               email: 'thomas@mail.com',
               notes: 'I really need to get someone to share my office with',
               language: 'en'
             }
           }
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a success message' do
      expect(response_json['message']).to eq 'Thanks for your answers! We\'ll be in touch'
    end

    it 'is expected to NOT have created a new Inquiry' do
      expect(Inquiry.all.count).to eq 0
    end
  end
end
