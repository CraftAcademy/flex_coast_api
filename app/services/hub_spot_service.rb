module HubSpotService
  @api_key = Rails.application.credentials.dig(:hub_spot, :api_key)
  def self.move(inquiry)
    inquiry = OpenStruct.new(inquiry) unless inquiry.is_a?(Inquiry)
    contact = find_or_create_contact(inquiry)
    id = contact[:vid]
    note = if inquiry.try(:officeProvider).nil?
             format_note(inquiry)
           else
             format_rent_out_note(inquiry)
           end
    timestamp = DateTime.now.to_i * 1000
    create_note(note, id, timestamp)
    true
  end

  def self.find_or_create_contact(inquiry)
    data = {
      properties: [
        { property: 'email', value: inquiry.email },
        { property: 'phone', value: inquiry.phone }
      ]
    }
    inquiry.try(:name).try(:present?) && data[:properties].push({ property: 'firstname', value: inquiry.name })
    begin
      contact = JSON.parse(
        RestClient.get("https://api.hubapi.com/contacts/v1/contact/email/#{inquiry.email}/profile?hapikey=#{@api_key}")
      ).symbolize_keys
    rescue StandardError => e
      contact = JSON.parse(e.response.body).symbolize_keys
    end
    if contact[:status] != 'error'
      RestClient.post(
        "https://api.hubapi.com/contacts/v1/contact/vid/#{contact[:vid]}/profile?hapikey=#{@api_key}",
        data.to_json, { content_type: :json, accept: :json }
      )
    else
      RestClient.post(
        "https://api.hubapi.com/contacts/v1/contact?hapikey=#{@api_key}",
        data.to_json, { content_type: :json, accept: :json }
      )
    end
    contact
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
