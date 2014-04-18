require "./db/seed_data"

def random_user
  @used_user_ids ||= []
  
  loop do
    @user = SeedData.get_random(User)
    break if !@used_user_ids.include?([@user.id])
  end
  @used_user_ids += [@user.id]
  @user

end

data = []
event_sessions = EventSession.all
event_sessions.each do |event_session|
  rando = random_user
  data += [
    { first_name: rando.first_name,
      last_name: rando.last_name,
      title: rando.title,
      organization_name: rando.organization_name,
      bio: Faker::Lorem.paragraph(7) + "\n\n" + Faker::Lorem.paragraph(5),
      speaker_type: Faker::Commerce.product_name,
      moderator: [true, false].sample,
      user_id: rando.id,
      event_session_id: event_session.id
    }
  ]
end

SeedData.new('EventSpeaker').load(data)