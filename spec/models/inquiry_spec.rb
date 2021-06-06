RSpec.describe Inquiry, type: :model do
  describe 'db table' do
    it { is_expected.to have_db_column(:size).of_type(:integer) }
    it { is_expected.to have_db_column(:variants).of_type(:integer) }
    it { is_expected.to have_db_column(:company).of_type(:string) }
    it { is_expected.to have_db_column(:peers).of_type(:boolean) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:flexible).of_type(:boolean) }
    it { is_expected.to have_db_column(:phone).of_type(:integer) }
    it { is_expected.to have_db_column(:start_date).of_type(:string) }
    it 'is expected to have db column locations of type array' do
      expect(subject[:locations]).kind_of?(Array)
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :email }
  end

  describe 'variant' do
    it { is_expected.to define_enum_for(:variants).with_values({ office: 1, open_space: 2}) }
  end

  describe 'Factory' do
    it 'should have valid factory' do
      expect(create(:inquiry)).to be_valid
    end
  end
end
