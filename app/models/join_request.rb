class JoinRequest < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user
  
  validates :user_id, presence: true
  validates :trip_id, presence: true
  validates :content, presence: true
end
