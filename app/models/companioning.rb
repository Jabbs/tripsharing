class Companioning < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user
  
  validates :trip_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: [:trip_id] }
  validates :role, presence: true
end