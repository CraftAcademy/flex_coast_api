
RSpec.describe Note, type: :model do
  describe 'DB table' do
    it {
      is_expected.to have_db_column(:body)
        .of_type(:text)
    }
  end

  it "is expected have valid factory" do
    expect(create(:note)).to be_valid
  end

  describe 'Associations' do
    it { is_expected.to belong_to :inquiry }
  end


  describe "Validations" do
    it { is_expected.to validate_presence_of :body }
  end
end
