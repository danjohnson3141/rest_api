require "./db/seed_data"

data = []
50.times do
  user_id = SeedData.get_random(User).id
  data += [
    { body: Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3), 
      user_id: user_id,
      post_id: SeedData.get_random(Post).id,
      created_by: user_id
    }
  ]
end

SeedData.new('PostComment').load(data)

data = []
20.times do
  data += [
    { url: 'https://www.attachment.com/attachment',
      post_comment_id: SeedData.get_random(PostComment).id,
      created_by: SeedData.get_random(User).id
    }
  ]
end

SeedData.new('PostCommentAttachment').load(data)

data = []
50.times do
  user_id = SeedData.get_random(User).id
  data += [
    { user_id: user_id,
      post_id: SeedData.get_random(Post).id,
      created_by: user_id
    }
  ]
end

SeedData.new('PostLike').load(data)

data = []
20.times do
  user_id = SeedData.get_random(User).id
  data += [
    { user_id: user_id,
      post_id: SeedData.get_random(Post).id,
      created_by: user_id
    }
  ]
end

SeedData.new('PostHide').load(data)

data = []
50.times do
  user_id = SeedData.get_random(User).id
  data += [
    { user_id: user_id,
      post_id: SeedData.get_random(Post).id,
      created_by: user_id
    }
  ]
end

SeedData.new('PostFollower').load(data)

data = []
20.times do
  data += [
    { url: 'https://www.attachment.com/attachment',
      post_id: SeedData.get_random(Post).id,
      created_by: SeedData.get_random(User).id
    }
  ]
end

SeedData.new('PostAttachment').load(data)