class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :trips, through: :taggings, :source => :taggable, :source_type => 'Trip'
  
  validates :name, presence: true, uniqueness: true
  
  before_save :fix_inputs
  
  def fix_inputs
    self.name = self.name.parameterize
  end
end
