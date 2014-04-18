require "./db/seed_data"



sponsors = Sponsor.all

data = []
id = 0
sponsors.each do |sponsor|
  group = nil
  event = nil
  group = ",+Group:+#{sponsor.group_id}" if sponsor.group_id.present?
  event = ",+Event:+#{sponsor.event_id}" if sponsor.event_id.present?
  id += 1
  graphic_link = "http://placehold.it/840x100#{SeedData.random_color}&text=[Sponsor:+#{sponsor.id}#{group}#{event},+Banner:+#{id}]"
  data += [{ id: id, sponsor_id: sponsor.id, link_url: 'www.evanta.com', graphic_link: graphic_link } ]
  id += 1
  graphic_link = "http://placehold.it/840x100#{SeedData.random_color}&text=[Sponsor:+#{sponsor.id}#{group}#{event},+Banner:+#{id}]"
  data += [{ id: id, sponsor_id: sponsor.id, link_url: 'www.evanta.com', graphic_link: graphic_link } ]
  id += 1
  graphic_link = "http://placehold.it/840x100#{SeedData.random_color}&text=[Sponsor:+#{sponsor.id}#{group}#{event},+Banner:+#{id}]"
  data += [{ id: id, sponsor_id: sponsor.id, link_url: 'www.evanta.com', graphic_link: graphic_link } ]
end

SeedData.new('BannerAd').load(data)