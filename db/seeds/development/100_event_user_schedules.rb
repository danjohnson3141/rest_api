require "./db/seed_data"

def random
  @used_session_ids ||= []
  
  loop do
    @session = SeedData.get_random(EventSession)
    break if !@used_session_ids.include?([@session.id])
  end
  @used_session_ids += [@session.id]
  @session

end

data = []
event_users = EventUser.all
event_users.each do |event_user|
  10.times do
    data += [ { event_user_id: event_user.id, event_session_id: random.id } ]
  end
end

SeedData.new('EventUserSchedule').load(data)