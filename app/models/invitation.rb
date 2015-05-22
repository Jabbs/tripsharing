class Invitation < ActiveRecord::Base
  
  belongs_to :trip
  belongs_to :user
  
  validates :trip_id, presence: true
  validates :user_id, presence: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: [:trip_id] }
end
