class Trip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
                    
  validates :name, presence: true, length: { maximum: 250 }
  validates :user_id, presence: true
  validates :description, length: { maximum: 5000 }
  validates :region, presence: true
  
  belongs_to :user
  has_many :join_requests, dependent: :destroy
  has_many :stops, dependent: :destroy
  accepts_nested_attributes_for :stops, allow_destroy: true
  has_many :locations, as: :locationable, dependent: :destroy
  accepts_nested_attributes_for :locations, allow_destroy: true
  has_many :image_attachments, as: :image_attachable, dependent: :destroy
  accepts_nested_attributes_for :image_attachments, allow_destroy: true
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  accepts_nested_attributes_for :taggings, allow_destroy: true
  has_many :followings, as: :followable, dependent: :destroy
  
  after_save :create_first_stop
  after_create :add_default_image
  
  STATES = {"1" => "incomplete", "2" => "accepting travelers", "3" => "private", "4" => "inactive", "5" => "complete", "6" => "in progress"}
  STATES_ARRAY = [["seeking travel companions", "2"],["private trip (invite only)", "3"]]
  GROUP_DYNAMICS = {"1" => "Female Or Male Travel Companions", "2" => "Female Travel Companions", "3" => "Male Travel Companions", "4" => "Couples", "5" => "Not Seeking Companions"}
  GROUP_DYNAMICS_ARRAY = [["travel companion(s)", "1"], ["female travel companion(s)", "2"], ["male travel companion(s)", "3"], ["traveling couple(s)", "4"], ["solo travel", "5"]]
  GROUP_COUNT_ARRAY = [["1", "1"], ["2", "2"], ["3", "3"], ["4", "4"], ["5", "5"], ["6-10", "6"], ["11-15", "7"], 
                     ["16+", "8"], ["tbd", "9"]]
  GROUP_COUNT = {"1" => "1", "2" => "2", "3" => "3", "4" => "4", "5" => "5", "6" => "6-10", "7" => "11-15", "8" => "16+", "9" => "tbd"}
  CURRENCIES = ["AUD","CAD","CHF","CNY","EUR","GBP","HKD","IDR","INR","JPY","MXN","NZD","RUB","SEK","SGD","THB","USD","ZAR"]
  IMAGE_REGION_DEFAULTS = {"1"=>["greece", "ireland", "spain"], "2"=>["animals", "cape_town", "mountains"], "3"=>["china", "great_wall", "temple"], "4"=>["himalayas", "rajasthan", "varanasi"], "5"=>["halong_bay", "kuala_lumpur", "singapore", "waikiki"], "6"=>["manpupuner"], "7"=>["chicago", "grand_canyon", "nyc", "pfeiffer_beach"], "8"=>["buenos_aires", "medellin", "rio"], "9"=>["cortina_falls", "panama"], "10"=>["new_zealand", "sydney"], "11"=>["dubai", "egypt"], "12"=>["moscow"], "13"=>["glacier"]}
  # http://www.maps.com/ref_map.aspx?pid=12873
  REGIONS = {"1" => "Europe", "2" => "Africa", "3" => "East Asia", "4" => "South Asia", "5" => "Southeast Asia", "6" => "North Asia", "7" => "N. America",
             "8" => "S. America", "9" => "Central America", "10" => "Australia, South Pacific", "11" => "Middle East", "12" => "Russia, C. Asia, Transc.",
             "13" => "Antarctica"}
  REGIONS_ARRAY = [["Europe", "1"], ["Africa", "2"], ["East Asia", "3"], ["South Asia", "4"], ["Southeast Asia", "5"], ["North Asia", "6"], ["N. America", "7"],
             ["S. America", "8"], ["Central America", "9"], ["Australia, South Pacific", "10"], ["Middle East", "11"], ["Russia, C. Asia, Transc.", "12"],
             ["Antarctica", "13"]]
  DURATIONS = {"1" => "1-3 days", "2" => "4-14 days", "3" => "15-24 days", "4" => "25-44 days", "5" => "45+ days", "6" => "unknown" }
  DURATIONS_ARRAY = [["(1-3 days) quick", "1"], ["(4-14 days) short", "2"], ["(15-24 days) avg", "3"], ["(25-44 days) long", "4"], ["(45+ days) extended", "5"], ["unknown", "6"]]
  DEPARTINGS_ARRAY = [["today", "1"], ["asap", "2"], ["this weekend", "3"], ["spring 2015", "4"], ["summer 2015", "5"], ["fall 2015", "6"], ["winter 2015", "7"],
               ["spring 2016", "8"], ["summer 2016", "9"], ["fall 2016", "10"], ["winter 2016", "11"]]
  DEPARTINGS = {"1" => "today", "2" => "asap", "3" => "this weekend", "4" => "spring 2015", "5" => "summer 2015", "6" => "fall 2015", "7" => "winter 2015",
                "8" => "spring 2016", "9" => "summer 2016", "10" => "fall 2016", "11" => "winter 2016"}
  FLEXIBILITY = {"1" => "no", "2" => "a little", "3" => "some", "4" => "a lot"}
  FLEXIBILITY_ARRAY = [["no", "1"], ["a little", "2"], ["some", "3"], ["a lot", "4"]]
  INTERESTS_ARRAY = [["Cultural immersion", "1"],["Exploring the city", "2"],["Partying / Clubbing", "3"],["Sports", "4"],
                    ["Backpacking", "5"],["Bicycling", "6"],["Overland and Safari", "7"],["Mountaineering", "8"],["Sailing / Boating", "9"],
                    ["Scuba / Snorkelling", "10"],["Skiing", "11"],["Trekking / Hiking", "12"],["Business / Networking", "13"],
                    ["Volunteering", "14"],["Wildlife / Ecology", "15"],["Food / Wine", "16"],["Drinking with locals", "17"],
                    ["Camping", "18"],["Museums", "19"],["Beaches", "20"]]
  INTERESTS = {"1" => "Cultural immersion", "2" => "Exploring the city", "3" => "Partying / Clubbing", "4" => "Sports", "5" => "Backpacking",
               "6" => "Bicycling", "7" => "Overland and Safari", "8" => "Mountaineering", "9" => "Sailing / Boating", "10" => "Scuba / Snorkelling",
              "11" => "Skiing", "12" => "Trekking / Hiking", "13" => "Business / Networking", "14" => "Volunteering", "15" => "Wildlife / Ecology",
              "16" => "Food / Wine", "17" => "Drinking with locals", "18" => "Camping", "19" => "Museums", "20" => "Beaches",}
  
  def self.search(region=nil, departs_at=nil, returns_at=nil, tag=nil)
    trips = self.where(state: "2")

    unless departs_at == nil || returns_at == nil || departs_at.blank? || returns_at.blank?
      trips = trips.where(departs_at: ( departs_at..returns_at) )
    end
    unless region.blank? || region == nil
      trips = trips.where(region: region)
    end
    unless tag.blank? || tag == nil
      trips = trips.joins(:tags).where(tags: {name: tag})
    end
    trips
  end
  
  def self.get_lonelyplanet_trips
    lp_trips = []
    url = "https://www.lonelyplanet.com/thorntree/forums/travel-companions.atom"
    xml = Nokogiri::XML(open(url))

    xml.search('entry').each do |entry|
      lp_entry = {}
    	lp_entry["id"] = entry.search('id').text
    	lp_entry["published"] = entry.search('published').text
    	lp_entry["updated"] = entry.search('updated').text
    	lp_entry["url"] = entry.search('url').text
    	lp_entry["title"] = entry.search('title').text
    	lp_entry["content"] = entry.search('content').text
    	lp_entry["author"] = entry.search('author').search('name').text
    	lp_trips << lp_entry
    end
    lp_trips
  end
  
  def self.create_from_survey(user, survey)
    trip = Trip.new(user_id: user.id)
    trip.initialized_with_signup = true
    trip.departing_category = survey.month
    trip.group_dynamics = survey.companion_type
    trip.add_predetermined_ages
    trip.region = survey.destination
    trip.name = Trip.generate_name(survey.month, survey.destination)
    trip.save!
  end
  
  def self.generate_name(departings_key, regions_key)
    x = ["adventure", "exploit", "venture", "getaway"]
    name = Trip::DEPARTINGS[departings_key] + " travel #{x.shuffle.first} to " + Trip::REGIONS[regions_key]
    name = name.titleize
    return name
  end
  
  def self.tagged_with(name)
    Tag.find_by_name(name).projects if Tag.find_by_name(name)
  end

  def self.tag_counts
    Tag.select("tags.*, count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end
  
  def hashtag_list
    tags.map{ |t| "#" + t.name}.join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end
    
  def create_first_stop
    unless self.stops.any? && self.departs_to.present?
      Stop.create_from_trip(self)
    end
  end
  
  def add_default_image
    self.default_image = Trip::IMAGE_REGION_DEFAULTS[region].shuffle.first
    self.save
  end
  
  def switch_to_state(state)
    self.state = state
    self.save
  end
  
  def add_predetermined_ages
    self.group_age_min = user.age - 4
    self.group_age_min = 18 if self.group_age_min < 18
    self.group_age_max = user.age + 4
  end
  
  def city_state
    self.location.city_state
  end
  
  def add_view_count
    self.view_count += 1
    save!
  end
  
  def deactivate
    self.state = "4"
    self.save!
  end
  
  def solo_trip?
    self.group_dynamics == "5" ? true : false
  end
  
  def incomplete?
    self.state == "1" ? true : false
  end
  
  def complete?
    self.state == "5" ? true : false
  end
  
  def active?
    self.state == "2" || self.state == "3" ? true : false
  end
  
  def public?
    self.state == "2" ? true : false
  end
  
  def private?
    self.state == "3" ? true : false
  end
  
  def inactive?
    self.state == "4" ? true : false
  end
  
  def price_info?
    if self.price_dollars_low.present? && self.price_dollars_high.present?  && self.currency.present? 
      true
    else
      false
    end
  end
end
