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
  
  def self.create_from_survey(user, survey)
    trip = Trip.new(user_id: user.id)
    trip.initialized_with_signup = true
    trip.departs_at = Date.strptime(survey.month,'%m/%d/%Y')
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
    # t.string   "hometown"
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
