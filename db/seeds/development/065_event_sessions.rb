require "./db/seed_data"

def random_event
  @used_events ||= []

  loop do
    @event = SeedData.get_random(Event)
    break if !@used_events.include?([@event.id])
  end
  @used_events += [@event.id]
  @event
end

event_sponsors = Sponsor.where("event_id IS NOT NULL").map(&:id)

data = []
Event.count.times do
  t = Time.now
  event = random_event
  8.times do |x|
    t = t + 1.hours
    data += [
      { name: Faker::Commerce.product_name,
        description: Faker::Company.catch_phrase + '. ' + Faker::Company.catch_phrase,
        start_date_time: t,
        end_date_time: t + 1.hours,
        track_name: Faker::Company.catch_phrase,
        session_type: Faker::Commerce.product_name,
        room_name: Faker::Commerce.product_name,
        event: event,
        sponsor_id: event_sponsors.sample,
        display_rank: [*1..3].sample
      }
    ]
  end
end
SeedData.new('EventSession').load(data)
