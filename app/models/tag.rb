class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :trips, through: :taggings, :source => :taggable, :source_type => 'Trip'
  
  validates :name, presence: true, uniqueness: true
  
  before_save :strip_inputs
  
  def strip_inputs
    self.name = self.name.strip.downcase
  end
end
