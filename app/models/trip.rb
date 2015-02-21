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
  GROUP_DYNAMICS = [["any travel companion(s)", "1"], ["female travel companion(s)", "2"], ["male travel companion(s)", "3"], ["traveling couple(s)", "4"], ["traveling family(s)", "5"]]
  CURRENCIES = ["AUD","CAD","CHF","CNY","EUR","GBP","HKD","IDR","INR","JPY","MXN","NZD","RUB","SEK","SGD","THB","USD","ZAR"]
  REGIONS = ["Europe", "Africa", "East Asia and the Pacific", "South Asia", "Middle East", "N. America",
                "S. America", "Central America"]
  
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
    case survey.companion_type
    when "1"
      trip.group_max = 2
    when "2"
      trip.group_max = 5
    when "3"
      trip.group_max = 10
    when "4"
      trip.group_max = 20
    when "5"
      trip.group_max = 4
    when "6"
      trip.group_max = 10
    when "7"
      trip.group_max = 10
    end
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
    self.age_min = user.age - 4
    self.age_min = 18 if self.age_min < 18
    self.age_max = user.age + 4
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
