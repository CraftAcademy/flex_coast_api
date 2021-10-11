RSpec.describe Inquiry, type: :model do
  let!(:mail_delivery) { ActionMailer::Base.deliveries }

  describe 'Db table' do
    it {
      is_expected.to have_db_column(:size)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:language)
        .of_type(:string)
    }
    it {
      is_expected.to have_db_column(:office_type)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:started_email_sent)
        .of_type(:boolean)
    }
    it {
      is_expected.to have_db_column(:peers)
        .of_type(:string)
    }
    it {
      is_expected.to have_db_column(:email)
        .of_type(:string)
    }
    it {
      is_expected.to have_db_column(:phone)
        .of_type(:string)
    }
    it {
      is_expected.to have_db_column(:inquiry_status)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:start_date)
        .of_type(:integer)
    }
    it 'is expected to have db column locations of type array' do
      expect(subject[:locations]).is_a?(Array)
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :email }
  end

  describe 'Office type' do
    it {
      is_expected.to define_enum_for(:office_type)
        .with_values({ office_space: 1, office_room: 2, fixed_space: 3, flexible_space: 4 })
    }
  end

  describe 'Inquiry status' do
    it {
      is_expected.to define_enum_for(:inquiry_status)
        .with_values({ pending: 1, started: 2, done: 3 })
    }
  end

  describe 'Start date' do
    it {
      is_expected.to define_enum_for(:start_date)
        .with_values({ now: 1, quarter: 2, unsure: 3 })
    }
  end

  describe 'Associations' do
    it { is_expected.to have_many :notes }
  end

  describe 'Hooks' do
    it 'is expected to send notification email to broker & submitter' do
      expect { create(:inquiry) }
        .to change { mail_delivery.count }.from(0).to(2)
    end
  end

  describe 'Factory' do
    it 'is expected to have valid factory' do
      expect(create(:inquiry)).to be_valid
    end
  end

  describe 'Email language is the same as :language on inquiry' do
    describe 'Swedish - se' do
      before do
        inquiry = create(:inquiry, language: 'se', inquiry_status: 'pending', broker: create(:user))
        inquiry.start
      end

      it 'submit mail is in swedish' do
        expect(mail_delivery[1].body).to include('Vi fick din förfrågan! Vårt team kommer att välja de bästa kontoren för just dig, förvänta att höra från oss om en dag eller två.')
      end

      it 'started mail is in swedish' do
        expect(mail_delivery[2].body).to include('Om du har några frågor innan jag återkommer till dig, så kan du nå mig på random_guy@email.com eller ringa/smsa mig på 031-123-4567')
      end
    end

    describe 'English - en' do
      before do
        inquiry = create(:inquiry, language: 'en', inquiry_status: 'pending', broker: create(:user))
        inquiry.start
      end

      it 'submit mail is in english' do
        expect(mail_delivery[1].body).to include('We received your inquiry and we have you covered! Our team will select the best offices for you, expect to hear from us withing a day or two.')
      end

      it 'started mail is in english' do
        expect(mail_delivery[2].body).to include('If you have any questions before I comeback to you. You can reach me on random_guy@email.com or text/call me at 031-123-4567')
      end
    end
  end

  describe 'Inquiry status events' do
    let(:pending_inquiry) { create(:inquiry, inquiry_status: 'pending', broker: create(:user)) }
    let(:started_inquiry) { create(:inquiry, inquiry_status: 'started') }
    let(:done_inquiry) { create(:inquiry, inquiry_status: 'done') }

    describe 'Pending inquiry' do
      it 'is expected to be able to ":start' do
        expect{
          pending_inquiry.start
        }
        .not_to raise_error
      end

      it 'is expected to not be able to ":finish"' do
        expect{
          pending_inquiry.finish
        }
        .to raise_error(StandardError)
        .with_message("You can't perform this on an inquiry that is 'pending'")
      end
    end

    describe 'Started inquiry' do
      it 'is expected to be able to ":set_to_pending"' do
        expect{
          started_inquiry.set_to_pending
        }
        .not_to raise_error
      end

      it 'is expected to be able to "finish"' do
        expect{
          started_inquiry.finish
        }
        .not_to raise_error
      end
    end

    describe 'Done inquiry' do
      it 'is expected to not be able to ":set_to_pending"' do
        expect{
          done_inquiry.set_to_pending
        }
        .to raise_error(StandardError)
        .with_message("You can't perform this on an inquiry that is 'done'")
      end

      it 'is expected to not be able to ":start"' do
        expect{
          done_inquiry.start
        }
        .to raise_error(StandardError)
        .with_message("You can't perform this on an inquiry that is 'done'")
      end
    end
  end

end
