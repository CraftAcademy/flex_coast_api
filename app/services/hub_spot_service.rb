module HubSpotService
  def self.move
    api_key = 'key'
    client = RestClient.post(
      "https://api.hubapi.com/contacts/v1/contact?hapikey=#{api_key}",
      {
        properties: [
          { property: 'email', value: 'thomas+5@craftacademy.se' },
          { property: 'phone', value: '031-101010' }
        ]
      }.to_json, { content_type: :json, accept: :json }
    )
    # binding.pry
    id = JSON.parse(client.body)['vid']
    note = RestClient.post(
      "https://api.hubapi.com/engagements/v1/engagements?hapikey=#{api_key}",
      {
        "engagement": {
          "active": true,
          "ownerId": 1,
          "type": 'NOTE',
          "timestamp": DateTime.now.to_i
        },
        "associations": {
          "contactIds": [id],
          "companyIds": [],
          "dealIds": [],
          "ownerIds": [],
          "ticketIds": []
        },
        
        "metadata": {
          "body": 'Here we will add inquiry details'
        }
      }.to_json, { content_type: :json, accept: :json }
    )
    true
  end
end
