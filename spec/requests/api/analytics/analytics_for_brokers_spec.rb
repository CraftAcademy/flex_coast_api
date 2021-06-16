RSpec.describe 'GET, api/analytics', type: :request do
  let(:visit_1) { create(:ahoy_visit) }
  let(:visit_2) { create(:ahoy_visit) }
  let!(:answer_event_1) do
    create(:ahoy_event,
           visit: visit_1,
           properties: { size: '3', value: '3', question: 'size' })
  end
  let!(:answer_event_2) do
    create(:ahoy_event,
           visit: visit_2,
           properties: { size: '1', value: '1', question: 'size' })
  end
  let!(:answer_event_3) do
    create(:ahoy_event,
           visit: visit_2,
           properties: { office_type: 'flex', value: 'flex', question: 'office_type' })
  end

  let!(:call_event) do
    create(:ahoy_event,
           visit: visit_2,
           name: 'phone_button',
           time: DateTime.now.utc)
  end

  before do
    get '/api/analytics'
  end

  it 'is expected to return a total number of visits' do
    expect(response_json['statistics']['visits']['total']).to eq 2
  end

  it 'is expected to respond with a list of data for each question in wizard' do
    expect(response_json['statistics']['events']['answers'].count).to eq 10
  end

  it 'is expected to sort wizard answers in an appropriate format' do
    expected_response = { 'value' => 2, 'name' => 'size' }
    expect(response_json['statistics']['events']['answers'].second).to eq expected_response
  end

  it 'is expected to respond with total number of phone button presses' do
    expect(response_json['statistics']['events']['calls']).to eq 1
  end
end
