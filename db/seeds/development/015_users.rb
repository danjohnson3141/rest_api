require "./db/seed_data"

def photo
  x = [200,250,300,320,420,480,500].sample
  y = [200,250,300,320,420,480,500].sample
  "http://placebeard.it/#{x}/#{y}"
end

data = [
  { id: 1,
    email: 'admin@access.evanta.com',
    alt_email: 'admin.johnson@evanta.com',
    password: 'evanta2014',
    first_name: 'Evanta',
    last_name: 'Access',
    title: 'Administrator',
    organization_name: 'Evanta',
    bio: 'System Administrator Account',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 2,
    email: 'michael.irey@evanta.com',
    alt_email: 'michael.irey@gmail.com',
    :authentication_token => 'BzJuU8ZkzE9QpAaLLVGs',
    password: 'evanta2014',
    first_name: 'Michael',
    last_name: 'Irey',
    title: 'Software Engineer',
    organization_name: 'Evanta',
    bio: 'President of the API group',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 3,
    email: 'daniel.johnson@evanta.com',
    alt_email: 'daniel.johnson@gmail.com',
    :authentication_token => 'aklsdjflaksjdf38383',
    password: 'evanta2014',
    first_name: 'Dan',
    last_name: 'Johnson',
    title: 'Web Developer',
    organization_name: 'Evanta',
    bio: 'Vice President of the API group',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 4,
    email: 'mike.caputo@evanta.com',
    alt_email: 'mike.caputo@gmail.com',
    authentication_token: '16ebbnpqh8c0wgrn',
    password: 'evanta2014',
    first_name: 'Mike',
    last_name: 'Caputo',
    title: 'Front-end Web Developer',
    organization_name: 'Evanta',
    bio: 'Vice President of the App group',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 5,
    email: 'nathan.brakken@evanta.com',
    alt_email: 'nathan.brakken@gmail.com',
    :authentication_token => 'Jwm8xZ1NUwpFcAu7Eb--',
    password: 'evanta2014',
    first_name: 'Nathan',
    last_name: 'Brakken',
    title: 'Web Developer',
    organization_name: 'Evanta',
    bio: 'President of the App group',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 6,
    email: 'brittany.budil@evanta.com',
    alt_email: 'brittnaynay@gmail.com',
    password: 'evanta2014',
    authentication_token: '2AwfoopsB5SWTGsjbhwC',
    first_name: 'Brittany',
    last_name: 'Budil',
    title: 'Project Manager',
    organization_name: 'Evanta',
    bio: 'Chief Executive Wireframer',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 7,
    email: 'graham.baas@evanta.com',
    alt_email: 'baas.effect@gmail.com',
    :authentication_token => '54321',
    password: 'evanta2014',
    first_name: 'Graham',
    last_name: 'Baas',
    title: 'Quality Assurance',
    organization_name: 'Evanta',
    bio: 'Tester Extrordinaire',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 8,
    email: 'ryan.pyeatt@evanta.com',
    alt_email: 'ryan.pyeatt@gmail.com',
    :authentication_token => 'qyee3k7nrlzb14wy',
    password: 'evanta2014',
    first_name: 'Ryan',
    last_name: 'Pyeatt',
    title: 'Vice President of IT',
    organization_name: 'Evanta',
    bio: '',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 9,
    email: 'adam@developmentnow.com',
    authentication_token: 'elqilpck60x04toz',
    password: 'evanta2014',
    first_name: 'Adam',
    last_name: 'Lorts',
    title: 'Dev Now Consultant',
    organization_name: 'Development Now',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 10,
    email: 'james.cliburn@developmentnow.com',
    authentication_token: 'z3ig4r7i679qudeh',
    password: 'evanta2014',
    first_name: 'James',
    last_name: 'Cliburn',
    title: 'Dev Now Consultant',
    organization_name: 'Development Now',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  },
  { id: 11,
    email: 'terry.waters@evanta.com',
    authentication_token: 'av8o21c2525y9a2j',
    password: 'evanta2014',
    first_name: 'Terry',
    last_name: 'Waters',
    title: 'Imagineer',
    organization_name: 'Evanta',
    user_role_id: 1,
    app_language_id: 1,
    photo: photo
  }

]

UserRole.all.each do |user_role|
  data += [{
    email: Faker::Internet.email,
    alt_email: Faker::Internet.free_email,
    authentication_token: Faker::Lorem.characters(16),
    password: 'evanta2014',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    title: 'Random User',
    organization_name: Faker::Company.name,
    bio: Faker::Lorem.paragraph(10),
    user_role_id: user_role.id,
    app_language_id: 1,
    photo: photo
  }]
end

20.times do
  data += [{
    email: Faker::Internet.email,
    alt_email: Faker::Internet.free_email,
    authentication_token: Faker::Lorem.characters(16),
    password: 'evanta2014',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    title: 'Random User',
    organization_name: Faker::Company.name,
    bio: Faker::Lorem.paragraph(10),
    user_role_id: SeedData.get_random(UserRole).id,
    app_language_id: 1,
    photo: photo
  }]
end

SeedData.new('User').load(data)

User.all.each do |user|
  user.update_columns(photo: "http://placehold.it/100x100#{SeedData.random_color}&text=#{user.first_name[0,1] + '+' + user.last_name[0,1]}")
end
