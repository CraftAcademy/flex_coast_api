require 'rails_helper'

RSpec.describe Inquiry, type: :model do
  describe 'db table' do
    it { is_expected.to have_db_column(:size).of_type(:integer) }
    it { is_expected.to have_db_column(:type).of_type(:boolean) }
    it { is_expected.to have_db_column(:company).of_type(:string) }
    it { is_expected.to have_db_column(:peers).of_type(:boolean) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:date).of_type(:date) }
    it { is_expected.to have_db_column(:flexible).of_type(:boolean) }
    it { is_expected.to have_db_column(:phone).of_type(:integer) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :size }
    it { is_expected.to validate_presence_of :type }
    it { is_expected.to validate_presence_of :company }
    it { is_expected.to validate_presence_of :peers }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :date }
    it { is_expected.to validate_presence_of :flexible }
    it { is_expected.to validate_presence_of :phone }
  end

  describe 'Factory' do
    it'should have valid factory' do
      expect(create(:inquiry)).to be_valid
    end
  end
end
