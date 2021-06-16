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
  let(:visit_headers) do
    {
      'Ahoy-Visit': visit_token,
      'Ahoy-Visitor': visitor_token,
      'Content-Type': 'application/json',
      'HTTP_USER_AGENT': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Safari/537.36'
    }
  end

  before do
    post '/api/ahoy/visits', params: visit_data, headers: visit_headers
    post '/api/ahoy/events', 
  end

  before do
    get '/api/analytics'
  end

  it 'is expected to return a total number of visits' do
    expect(response_json['statistics']['events']['answers']).to eq 10
  end

  it 'is expected to respond with a list of events' do
    expect(response_json['statistics']['events']['answers']).to eq ''
  end
end
