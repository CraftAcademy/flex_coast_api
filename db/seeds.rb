User.destroy_all
Inquiry.destroy_all

puts 'generating intelligent life...'
broker = User.create(
  email: "johndoe@flexcoast.se", 
  name: "John Doe", 
  password: "password"
)
puts 'creating inquiries...'
inquiries = Inquiry.create ([
  {
    "id": 1,
    "size": "1",
    "office_type": "office",
    "peers": true,
    "email": "lucy@example.com",
    "flexible": 'yes',
    "phone": "0707123456",
    "locations": [
      "Gothenburg City",
      "Southside",
      "Gothenburg City",
      "Southside"
    ],
    "start_date": "21 Jun 2021",
    "inquiry_status": "pending"
  },
  {
    "id": 2,
    "size": "2",
    "office_type": "open_space",
    "peers": true,
    "email": "kimmy@example.com",
    "flexible": 'no',
    "phone": "0707123456",
    "locations": ["Gothenburg City", "Southside"],
    "start_date": "21 Jun 2021",
    "inquiry_status": "done",
    "broker_id": broker.id 
  },
  {
    "id": 3,
    "size": "1",
    "office_type": "combined",
    "peers": true,
    "email": "chrissy@example.com",
    "flexible": 'mixed',
    "phone": "0707123456",
    "locations": ["Gothenburg City", "Southside"],
    "start_date": "21 Jun 2021",
    "inquiry_status": "started",
    "broker_id": broker.id 

  },
  {
    "id": 4,
    "size": "6",
    "office_type": "open_space",
    "peers": false,
    "email": "markus@volvo.com",
    "flexible": 'mixed',
    "phone": "0707123456",
    "locations": ["Gothenburg City", "Nordstan"],
    "start_date": "05 Jul 2021",
    "inquiry_status": "started",
    "broker_id": broker.id 
  },
  {
    "id": 5,
    "size": "15",
    "office_type": "office",
    "peers": true,
    "email": "lotta@spoyify.com",
    "flexible": 'yes',
    "phone": "0707123456",
    "locations": ["Gothenburg City"],
    "start_date": "04 Aug 2021",
    "inquiry_status": "started",
    "broker_id": broker.id 
  },
  {
    "id": 6,
    "size": "4",
    "office_type": "open_space",
    "peers": true,
    "email": "bob@burgers.com",
    "flexible": 'no',
    "phone": "0707123456",
    "locations": ["Gothenburg City"],
    "start_date": "15 Jun 2021",
    "inquiry_status": "started",
    "broker_id": broker.id 
  }
])

