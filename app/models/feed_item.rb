class FeedItem < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :activity
  
  validates :activity_id, presence: true
  validates :user_id, presence: true
end
