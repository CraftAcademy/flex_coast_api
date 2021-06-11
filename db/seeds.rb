puts 'creating inquiries...'
inquiries = Inquiry.create ([
  {
    "id": 1,
    "size": "1",
    "office_type": "office",
    "company": "Flex Coast",
    "peers": true,
    "email": "lucy@example.com",
    "flexible": true,
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
    "office_type": "office",
    "company": "Craft Academy",
    "peers": true,
    "email": "kimmy@example.com",
    "flexible": true,
    "phone": "0707123456",
    "locations": ["Gothenburg City", "Southside"],
    "start_date": "21 Jun 2021",
    "inquiry_status": "done"
  },
  {
    "id": 3,
    "size": "1",
    "office_type": "office",
    "company": "ICA",
    "peers": true,
    "email": "chrissy@example.com",
    "flexible": true,
    "phone": "0707123456",
    "locations": ["Gothenburg City", "Southside"],
    "start_date": "21 Jun 2021",
    "inquiry_status": "started"
  },
  {
    "id": 4,
    "size": "6",
    "office_type": "open_space",
    "company": "Volvo",
    "peers": false,
    "email": "markus@volvo.com",
    "flexible": false,
    "phone": "0707123456",
    "locations": ["Gothenburg City", "Nordstan"],
    "start_date": "05 Jul 2021",
    "inquiry_status": "started"
  },
  {
    "id": 5,
    "size": "15",
    "office_type": "office",
    "company": "Spotify",
    "peers": true,
    "email": "lotta@spoyify.com",
    "flexible": true,
    "phone": "0707123456",
    "locations": ["Gothenburg City"],
    "start_date": "04 Aug 2021",
    "inquiry_status": "started"
  },
  {
    "id": 6,
    "size": "4",
    "office_type": "open_space",
    "company": "Bob's Burgers",
    "peers": true,
    "email": "bob@burgers.com",
    "flexible": true,
    "phone": "0707123456",
    "locations": ["Gothenburg City"],
    "start_date": "15 Jun 2021",
    "inquiry_status": "started"
  }
])
