class Location < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :country, :state, :zip, :latitude,
                  :longitude, :display_on_map
  belongs_to :locationable, polymorphic: true
  
  geocoded_by :full_address
  # acts_as_gmappable :process_geocoding => false
  
  after_validation :geocode, :if => :address_changed?
  
  validates :country, presence: true
  
  scope :trips, ->() { where(locationable_type: 'Trip') }
  scope :with_coordinates, ->() {
    where("latitude IS NOT NULL")
    where("longitude IS NOT NULL")
  }
  
  def address_changed?
    attrs = %w(address1 address2 city state zip country)
    attrs.any?{|a| send "#{a}_changed?"}
  end
  
  def city_country
    if self.city
      if self.country == "United States of America"
        "#{self.city}, #{self.state}, USA"
      else
        "#{self.city}, #{self.country}"
      end
    end
  end
  
  def city_state
    "#{city}, #{state}"
  end
  
  def city_state?
    if !self.city.blank? && !self.state.blank?
      true
    else
      false
    end
  end
  
  def city_state_zip?
    if !self.city.blank? && !self.state.blank? && !self.zip.blank?
      true
    else
      false
    end
  end
  
  def full_address
    "#{address1}, #{address2}, #{city}, #{state}, #{zip}, #{country}"
  end
  
  def gmaps4rails_address
  # describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
    "#{address1}, #{address2}, #{city}, #{state}, #{zip}, #{country}"
  end
end
