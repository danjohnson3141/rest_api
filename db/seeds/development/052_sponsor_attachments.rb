data = []

def url
  x = [200,250,300,320,420,480,500].sample
  y = [200,250,300,320,420,480,500].sample
  "http://placekitten.com/#{x}/#{y}"
end

Sponsor.all.each do |sponsor|
  data += [
    { sponsor: sponsor,
      url: url
    }
  ]
end

SeedData.new('SponsorAttachment').load(data)
