RSpec.describe Inquiry, type: :model do
  let!(:mail_delivery){ ActionMailer::Base.deliveries }

  describe 'db table' do
    it { 
      is_expected.to have_db_column(:size)
      .of_type(:integer) 
    }
    it { is_expected.to have_db_column(:office_type).of_type(:integer) }
    it { is_expected.to have_db_column(:company).of_type(:string) }
    it { is_expected.to have_db_column(:peers).of_type(:boolean) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:flexible).of_type(:boolean) }
    it { is_expected.to have_db_column(:phone).of_type(:integer) }
    it { is_expected.to have_db_column(:start_date).of_type(:string) }
    it { is_expected.to have_db_column(:inquiry_status).of_type(:integer) }
    it 'is expected to have db column locations of type array' do
      expect(subject[:locations]).kind_of?(Array)
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :email }
  end

  describe 'Office type' do
    it { is_expected.to define_enum_for(:office_type)
    .with_values({ office: 1, open_space: 2}) }
  end

  describe 'Inquiry status' do
    it { is_expected.to define_enum_for(:inquiry_status)
    .with_values({ pending: 1, started: 2, done: 3}) }
  end

  describe 'Hooks' do
    it 'is expected to send notification email' do
      expect {create(:inquiry)}
      .to change{mail_delivery.count}.from(0).to(1)
    end
  end

  describe 'Factory' do
    it 'is expected to have valid factory' do
      expect(create(:inquiry)).to be_valid
    end
  end
end
