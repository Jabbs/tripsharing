class Trip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
                    
  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true
  
  belongs_to :user
  has_many :locations, as: :locationable, dependent: :destroy
  accepts_nested_attributes_for :locations, allow_destroy: true
  has_many :image_attachments, as: :image_attachable, dependent: :destroy
  accepts_nested_attributes_for :image_attachments, allow_destroy: true
  
  STATES = ["pending", "active"]
  
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
      trip.group_max = 4
    when "5"
      trip.group_max = 10
    when "6"
      trip.group_max = 10
    end
    x = ["adventure", "experience", "exploit", "trip", "undertaking", "venture", "getaway", "happening", "destination"]
    y = ["friends", "companions", "buddies"]
    # concat a name
    trip.name = survey.month + " traveling #{y.shuffle.first} group #{x.shuffle.first} to " + survey.destination.split(',').first
    trip.save!
    trip.locations.create(unparsed: survey.destination)
  end
  
  def city_state
    self.location.city_state
  end
  
  def add_view_count
    self.view_count += 1
    save!
  end
  
  def active?
    self.state == "active" ? true : false
  end
  
  def inactive?
    self.state == "active" ? false : true
  end
end
