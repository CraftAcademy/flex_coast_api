module HubSpotService
  @api_key = Rails.application.credentials.dig(:hub_spot, :api_key)
  def self.move(inquiry)
    inquiry = OpenStruct.new(inquiry) unless inquiry.is_a?(Inquiry)
    contact = create_contact(inquiry)
    id = JSON.parse(contact.body)['vid']
    note = if inquiry.try(:officeProvider) == 'true'
             format_rent_out_note(inquiry)
           else
             format_note(inquiry)             
           end
    timestamp = DateTime.now.to_i * 1000
    create_note(note, id, timestamp)
    true
  end

  private

  def self.create_contact(inquiry)
    RestClient.post(
      "https://api.hubapi.com/contacts/v1/contact?hapikey=#{@api_key}",
      {
        properties: [
          { property: 'email', value: inquiry.email },
          { property: 'phone', value: inquiry.phone }
        ]
      }.to_json, { content_type: :json, accept: :json }
    )
  end

  def self.create_note(note, id, timestamp)
    RestClient.post(
      "https://api.hubapi.com/engagements/v1/engagements?hapikey=#{@api_key}",
      {
        engagement: {
          active: true,
          type: 'NOTE',
          timestamp: timestamp
        },
        associations: {
          contactIds: [id]
        },
        metadata: {
          "body": note
        }
      }.to_json, { content_type: :json, accept: :json }
    )
  end

  def self.format_note(inquiry)
    locations = inquiry.locations.map do |location|
      location
    end
    "The following data was provided by the user:</br>
    <ul>
    <li>Size: #{inquiry.size}</li>
    <li>Office type: #{inquiry.office_type}</li>
    <li>Peers: #{inquiry.peers}</li>
    <li>Email: #{inquiry.email}</li>
    <li>Flexible: #{inquiry.flexible}</li>
    <li>Phone: #{inquiry.phone}</li>
    </ul>
    Locations: #{locations}"
  end

  def self.format_rent_out_note(inquiry)
    "The following information was provided by the user:</br>
    <ul>
    <li>Name: #{inquiry.name}</li>
    <li>Email: #{inquiry.email}</li>
    <li>Phone: #{inquiry.phone}</li>
    <li>Notes: #{inquiry.notes}</li>
    </ul>"
  end
end
