class Survey < ActiveRecord::Base
  belongs_to :user
  
  validates :destination, presence: true, length: { maximum: 255 }
  validates :hometown, presence: true, length: { maximum: 255 }
end
