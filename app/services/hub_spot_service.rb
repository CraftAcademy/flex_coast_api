module HubSpotService
  def self.move(inquiry)
    api_key = '56f4911a-36e3-4b55-8377-7e9bd190e402'
    contact = RestClient.post(
      "https://api.hubapi.com/contacts/v1/contact?hapikey=#{api_key}",
      {
        properties: [
          { property: 'email', value: inquiry.email },
          { property: 'phone', value: inquiry.phone }
        ]
      }.to_json, { content_type: :json, accept: :json }
    )
    # binding.pry
    id = JSON.parse(contact.body)['vid']
    locations = inquiry.locations.map do |location|
      location
    end
    note = "
    The following data was provided by the user:</br>
    <ul>
    <li>Size: #{inquiry.size}</li>
    <li>Office type: #{inquiry.office_type}</li>
    <li>Peers: #{inquiry.peers}</li>
    <li>Email: #{inquiry.email}</li>
    <li>Flexible: #{inquiry.flexible}</li>
    <li>Phone: #{inquiry.phone}</li>
    </ul>

    Locations: #{locations}"

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
          "contactIds": [id]
        },

        "metadata": {
          "body": note
        }
      }.to_json, { content_type: :json, accept: :json }
    )
    true
  end
end
