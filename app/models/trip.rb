class Trip < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  attr_accessible :age_max, :age_min, :description, :expires_at, :group_size, :name, :location_attributes,
                  :image_attachments_attributes, :active
                    
  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true
  
  belongs_to :user
  has_one :location, as: :locationable, dependent: :destroy
  accepts_nested_attributes_for :location, allow_destroy: true
  has_many :image_attachments, as: :image_attachable, dependent: :destroy
  accepts_nested_attributes_for :image_attachments, allow_destroy: true
  
  def add_view_count
    self.view_count += 1
    save!
  end
  
  def inactive?
    self.active == true ? false : true
  end
end
