class Activity < ActiveRecord::Base
  
  # associations
  belongs_to :user
  belongs_to :trackable, polymorphic: true
  has_many :feed_items

  # validations
  validates :trackable_type, presence: true
  validates :trackable_id, presence: true
  validates :action, presence: true
  validates :user_id, presence: true
end
