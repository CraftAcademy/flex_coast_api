RSpec.describe Inquiry, type: :model do
  let!(:mail_delivery) { ActionMailer::Base.deliveries }

  describe 'Db table' do
    it {
      is_expected.to have_db_column(:size)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:office_type)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:flexible)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:started_email_sent)
        .of_type(:boolean)
    }
    it {
      is_expected.to have_db_column(:peers)
        .of_type(:boolean)
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

  describe 'Flexible' do
    it {
      is_expected.to define_enum_for(:flexible)
        .with_values({ yes: 1, no: 2, mixed: 3 })
    }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :email }
  end

  describe 'Office type' do
    it {
      is_expected.to define_enum_for(:office_type)
        .with_values({ office: 1, open_space: 2, combined: 3 })
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

    it 'is expected to only send notification email of inquiry started once' do
      inquiry = create(:inquiry)
      inquiry.start
      inquiry.set_to_pending
      inquiry.start
      binding.pry
    end
  end

  describe 'Factory' do
    it 'is expected to have valid factory' do
      expect(create(:inquiry)).to be_valid
    end
  end

  describe 'Inquiry status events' do
    let(:pending_inquiry) { create(:inquiry, inquiry_status: 'pending') }
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
