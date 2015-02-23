class Trip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
                    
  validates :name, presence: true, uniqueness: true, length: { maximum: 250 }
  validates :user_id, presence: true
  validates :description, length: { maximum: 5000 }
  
  belongs_to :user
  has_many :locations, as: :locationable, dependent: :destroy
  accepts_nested_attributes_for :locations, allow_destroy: true
  has_many :image_attachments, as: :image_attachable, dependent: :destroy
  accepts_nested_attributes_for :image_attachments, allow_destroy: true
  
  STATES = {"1" => "incomplete", "2" => "accepting travelers", "3" => "private", "4" => "inactive", "5" => "complete", "6" => "in progress"}
  STATES_ARRAY = [["seeking travel companions", "2"],["private trip (invite only)", "3"]]
  GROUP_DYNAMICS = [["travel companion(s)", "1"], ["female travel companion(s)", "2"], ["male travel companion(s)", "3"], ["traveling couple(s)", "4"], ["traveling family(s)", "5"], ["solo travel", "6"]]
  CURRENCIES = ["AUD","CAD","CHF","CNY","EUR","GBP","HKD","IDR","INR","JPY","MXN","NZD","RUB","SEK","SGD","THB","USD","ZAR"]
  REGIONS = {"1" => "Europe", "2" => "Africa", "3" => "East Asia and the Pacific", "4" => "South Asia", "5" => "Middle East", "6" => "N. America",
             "7" => "S. America", "8" => "Central America"}
  REGIONS_ARRAY = [["Europe", "1"], ["Africa", "2"], ["East Asia and the Pacific", "3"], ["South Asia", "4"], ["Middle East", "5"], ["N. America", "6"],
             ["S. America", "7"], ["Central America", "8"]]
  DURATIONS = [["weekend", "1"], ["4-10 days", "2"], ["11-20 days", "3"], ["21-30 days", "4"], ["31+ days", "5"], ["unknown", "6"]]
  DEPARTINGS = [["today", "1"], ["asap", "2"], ["this weekend", "3"], ["spring 2015", "4"], ["summer 2015", "5"], ["fall 2015", "6"], ["winter 2015", "7"],
               ["spring 2016", "8"], ["summer 2016", "9"], ["fall 2016", "10"], ["winter 2016", "11"]]
  FLEXIBILITY = [["no", "1"], ["a little", "2"], ["some", "3"], ["a lot", "4"]]
  INTERESTS = [
    ["Cultural immersion", "1"],
    ["Exploring the city", "2"],
    ["Partying / Clubbing", "3"],
    ["Sports", "4"],
    ["Backpacking", "5"],
    ["Bicycling", "6"],
    ["Overland and Safari", "7"],
    ["Mountaineering", "8"],
    ["Sailing / Boating", "9"],
    ["Scuba / Snorkelling", "10"],
    ["Skiing", "11"],
    ["Trekking / Hiking", "12"],
    ["Business / Networking", "13"],
    ["Volunteering", "14"],
    ["Wildlife / Ecology", "15"],
    ["Food / Wine", "16"],
    ["Drinking with locals", "17"],
    ["Camping", "18"],
    ["Museums", "19"],
    ["Beaches", "20"]
  ]
  
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
    trip.departs_at = Date.strptime(survey.month,'%B %Y')
    trip.group_dynamics = survey.companion_type
    trip.add_predetermined_ages
    trip.region = survey.destination
    x = ["adventure", "exploit", "venture", "getaway"]
    y = ["friends", "companions", "buddies"]
    # concat a name
    trip.name = survey.month + " travel #{x.shuffle.first} to " + survey.destination.split(',').first
    trip.save!
    trip.locations.create(unparsed: survey.destination)
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
  
  def incomplete?
    self.state == "1" ? true : false
  end
  
  def complete?
    self.state == "5" ? true : false
  end
  
  def active?
    self.state == "2" || "3" ? true : false
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
