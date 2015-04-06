class Friending < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  validates :friend, presence: true, uniqueness: true
  validates :user_id, presence: true
end
