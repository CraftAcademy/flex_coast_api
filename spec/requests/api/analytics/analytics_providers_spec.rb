RSpec.describe 'GET, api/analytics', type: :request do
  let(:visitor_token) { SecureRandom.uuid }
  let(:visit_token) { SecureRandom.uuid }
  let!(:inquiry) { 2.times { create(:inquiry) } }
  let(:visit_data) do
    { visit_token: visit_token,
      visitor_token: visitor_token,
      js: true,
      platform: 'Web',
      screen_height: 1080,
      screen_width: 1920 }.to_json
  end
  let(:wizard_event_data) do
    {
      visit_token: visit_token,
      visitor_token: visitor_token,
      events: [
        {
          name: 'answer',
          properties: {
            value: 4,
            question: 'size',
            size: 4
          },
          time: "2018-01-01T00:00:00-07:00"
        }
      ]
    }.to_json
  end
  let(:call_button_event_data) do
    {
      visit_token: visit_token,
      visitor_token: visitor_token,
      events: [
        {
          name: 'phone_button',
          time: "2018-01-01T00:00:00-07:00"
        }
      ]
    }.to_json
  end
  let(:headers) do
    {
      'Ahoy-Visit': visit_token,
      'Ahoy-Visitor': visitor_token,
      'Content-Type': 'application/json',
      'HTTP_USER_AGENT': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Safari/537.36'
    }
  end

  before do
    post '/api/ahoy/visits', params: visit_data, headers: headers
    post '/api/ahoy/events', params: wizard_event_data, headers: headers 
    post '/api/ahoy/events', params: wizard_event_data, headers: headers 
    post '/api/ahoy/events', params: wizard_event_data, headers: headers 
    post '/api/ahoy/events', params: call_button_event_data, headers: headers
  end

  before do
    get '/api/analytics'
  end

  it 'is expected to return a total number of visits' do
    expect(response_json['statistics']['visits']['total']).to eq 1
  end

  it 'is expected to respond with a list of data for each question in wizard' do
    expect(response_json['statistics']['events']['answers'].count).to eq 10
  end

  it 'is expected to sort wizard answers in an appropriate format' do
    expected_response = { "value" => 3, "name" => 'size' }
    expect(response_json['statistics']['events']['answers'].second()).to eq expected_response
  end

  it 'is expected to respond with total number of phone button presses' do
    expect(response_json['statistics']['events']['calls']).to eq 1
  end
end
