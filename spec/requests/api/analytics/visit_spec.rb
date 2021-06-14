RSpec.describe 'POST /api/ahoy/visits', type: :request do
  before do
    events_json = '[{"name":"Site visit","properties":{},"time":1623687728.934,"id":"3b1ca2be-024e-4608-9048-5c76bf1730e9","js":true}]'
    post '/api/ahoy/visits', params: {
      visit_token: SecureRandom.uuid,
      visitor_token: SecureRandom.uuid,
      js: true,
      name: 'Site visit',
      time: DateTime.now.to_i
    }
  end

  it 'does something' do
    binding.pry
  end
end
