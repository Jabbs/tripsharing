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
