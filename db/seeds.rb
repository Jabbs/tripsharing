# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.find_by_email("petejabbour1@gmail.com").present?
  email = "petejabbour1@gmail.com"
  first_name = "Peter"
  last_name = "Jabbour"
  password = "testing"
  gender = "male"
  home_airport = "ORD - Chicago O'Hare International Airport"
  education = "Molecular Biology and Business"
  bio = "Some time back, I took a trip to Vietnam with some people I had not previously met (other than through mutual Facebook friends). It was an amazing experience. After only a two week trip many of us became good friends and keep in touch to this day. It amazed me how the travel experience (and experience in general, sad or happy) brings us close together in such a short amount of time. I want to bring that experience to everyone who is willing to try."
  occupation = "Web Developer"
  birthday = Date.strptime("07/30/1982",'%m/%d/%Y')
  location = "Chicago, IL, USA"
  status = "2"
  country_blob = "39,50,60,96,219,242"
  language_blob = "15"
  interest_blob = "1-3,2-3,3-1,4-1,5-2"
  region_blob = "1,2,3,5,7,8,9,10"
  User.create!(email: email, first_name: first_name, last_name: last_name, password: password, gender: gender,
              bio: bio, occupation: occupation, birthday: birthday, location: location, status: status,
              country_blob: country_blob, language_blob: language_blob, interest_blob: interest_blob,
              home_airport: home_airport, education: education, region_blob: region_blob)
end

15.times do
  email = Faker::Internet.email
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  password = "testing"
  gender = ["male", "female"].shuffle.first
  home_airport = "ORD - Chicago O'Hare International Airport"
  education = Faker::Company.catch_phrase
  bio = Faker::Lorem.paragraph(rand(7..15)) + "<br><br>" + Faker::Lorem.paragraph(rand(7..15))
  occupation = Faker::Company.catch_phrase
  birthday = Faker::Date.between(60.years.ago, 21.years.ago)
  location = Faker::Address.city + ", " + Faker::Address.country
  status = User::STATUS.keys.shuffle.first
  country_blob = User::COUNTRIES.keys.shuffle.first(rand(1..10)).join(",")
  language_blob = User::LANGUAGES.keys.shuffle.first(rand(1..3)).join(",")
  region_blob = Trip::REGIONS.keys.shuffle.first(rand(1..10)).join(",")
  interest_blob = User::INTERESTS.keys.map { |k| k + "-" + rand(1..3).to_s }.join(",")
  User.create!(email: email, first_name: first_name, last_name: last_name, password: password, gender: gender,
              bio: bio, occupation: occupation, birthday: birthday, location: location, status: status,
              country_blob: country_blob, language_blob: language_blob, interest_blob: interest_blob,
              home_airport: home_airport, education: education, region_blob: region_blob)
end

120.times do
  region = Trip::REGIONS.keys.shuffle.first
  departing_category = Trip::DEPARTINGS.keys.shuffle.first
  name = Trip.generate_name(departing_category, region)
  description = Faker::Lorem.paragraph(rand(7..15)) + "<br><br>" + Faker::Lorem.paragraph(rand(7..15)) + "<br><br>" + Faker::Lorem.paragraph(rand(7..15))
  user_id = User.pluck(:id).shuffle.first
  departs_at = Faker::Date.between(Date.today, 120.days.from_now)
  group_dynamics = Trip::GROUP_DYNAMICS.keys.shuffle.first
  state = Trip::STATES.keys.shuffle.first
  returns_at = departs_at + rand(1..60).days
  time_flexibility = Trip::FLEXIBILITY.keys.shuffle.first
  group_count = Trip::GROUP_COUNT.keys.shuffle.first
  group_age_min = rand(21..35).to_s
  group_age_max = (group_age_min.to_i + rand(5..15)).to_s
  reason = Faker::Lorem.paragraph(10) + "<br>" + Faker::Lorem.paragraph(10)
  default_image = Trip::IMAGE_REGION_DEFAULTS[region].shuffle.first
  trip = Trip.new(region: region, departing_category: departing_category, name: name, description: description,
               user_id: user_id, departs_at: departs_at, group_dynamics: group_dynamics, state: state,
               returns_at: returns_at, time_flexibility: time_flexibility, group_count: group_count, group_age_min: group_age_min,
               group_age_max: group_age_max, reason: reason, default_image: default_image)
  
  Trip::INTERESTS.keys.shuffle.first(rand(2..6)).each do |k|
    name = Trip::INTERESTS[k].parameterize
    if Tag.find_by_name(name)
     t = Tag.find_by_name(name)
    else
     t = Tag.create!(name: name)
    end
    trip.taggings.build(tag_id: t.id)
  end
  trip.save!
  
  stop_date = departs_at
  rand(2..7).times do
    to_date = stop_date
    trip.stops.create!(to_name: Faker::Address.city, to_name_dest: Faker::Address.city, to_date: to_date)
    stop_date = stop_date + rand(1..3).days
  end
  
end
