class JoinRequest < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user
  
  # scopes
  scope :unviewed, ->() { where(viewed: false) }
  scope :with_badges_unviewed, ->() { where(badge_viewed: false) }
  
  validates :user_id, presence: true, uniqueness: { scope: [:trip_id] }
  validates :trip_id, presence: true
  validates :content, presence: true
  
  STATES = {"0" => "pending", "1" => "accepted", "2" => "declined"}
  STATES_ARRAY = [["pending", "0"],["accepted", "1"],["declined", "2"]]
  
  def change_to_accepted
    self.state = "1"
    self.save!
    self.trip.companionings.create!(user_id: self.user.id)
  end
  
  def change_to_declined
    self.state = "2"
    self.save!
  end
  
  def pending?
    self.state == "0" ? true : false
  end
  
  def accepted?
    self.state == "1" ? true : false
  end
  
  def declined?
    self.state == "2" ? true : false
  end
end
