RSpec.describe Inquiry, type: :model do
  let!(:mail_delivery) { ActionMailer::Base.deliveries }

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

  describe 'db table' do
    it {
      is_expected.to have_db_column(:size)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:office_type)
        .of_type(:integer)
    }
    it {
      is_expected.to have_db_column(:company)
        .of_type(:string)
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
      is_expected.to have_db_column(:flexible)
        .of_type(:boolean)
    }
    it {
      is_expected.to have_db_column(:phone)
        .of_type(:string)
    }
    it {
      is_expected.to have_db_column(:start_date)
        .of_type(:string)
    }
    it {
      is_expected.to have_db_column(:inquiry_status)
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
        .with_values({ office: 1, open_space: 2, both: 3 })
    }
  end

  describe 'Inquiry status' do
    it {
      is_expected.to define_enum_for(:inquiry_status)
        .with_values({ pending: 1, started: 2, done: 3 })
    }
  end

  describe 'Associations' do
    it { is_expected.to have_many :notes }
  end

  describe 'Hooks' do
    it 'is expected to send notification email' do
      expect { create(:inquiry) }
        .to change { mail_delivery.count }.from(0).to(1)
    end
  end

  describe 'Factory' do
    it 'is expected to have valid factory' do
      expect(create(:inquiry)).to be_valid
    end
  end
end
