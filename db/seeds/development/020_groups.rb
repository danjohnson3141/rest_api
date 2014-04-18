require "./db/seed_data"

data = [
  { id: 1,
    name: 'CIO', 
    description: 'CIO Group',
    group_type_id: 1,
    owner_user_id: SeedData.get_random(User).id
  }, 
  { id: 2,
    name: 'CISO', 
    description: 'CISO Group',
    group_type_id: 1,
    owner_user_id: SeedData.get_random(User).id
  },
  { id: 3,
    name: 'CDO', 
    description: 'Chief Data Officer Group',
    group_type_id: 1,
    owner_user_id: SeedData.get_random(User).id
  },
  { id: 4,
    name: '2014 Chicago CIO Executive Summit', 
    description: '2014 Chicago CIO Executive Summit',
    group_type_id: 1,
    owner_user_id: SeedData.get_random(User).id
  },
  { id: 5,
    name: 'Private Boardroom', 
    description: 'Private Boardroom Group',
    group_type_id: 2,
    owner_user_id: SeedData.get_random(User).id
  },
  { id: 6,
    name: 'Super Secret Group', 
    description: 'Super Secret Group',
    group_type_id: 3,
    owner_user_id: SeedData.get_random(User).id
  }
]

SeedData.new('Group').load(data)