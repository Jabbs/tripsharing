class Trip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  attr_accessible :age_max, :age_min, :description, :expires_at, :group_size, :name, :location_attributes
  
  validates :name, presence: true, uniqueness: true
  
  has_one :location, as: :locationable, dependent: :destroy
  accepts_nested_attributes_for :location, allow_destroy: true
end
