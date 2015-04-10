class Friending < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  validates :user_id, presence: true
  validates :friend, presence: true, uniqueness: {:scope => :user_id}
end
