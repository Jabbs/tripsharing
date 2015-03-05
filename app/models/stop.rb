class Stop < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user
  
  validates :to_name, presence: true
  validates :order, uniqueness: {scope: :trip_id}, presence: true
  
  after_create :parse_airport_to_name
  after_create :parse_airport_from_name
  
  TRANSPORTATION_TYPES = {"1" => "flight", "2" => "car"}
  TRANSPORTATION_TYPES_ARRAY = [["flight", "1"], ["car", "2"]]
  
  def self.create_from_trip(trip)
    stop = trip.stops.new(user_id: trip.user_id)
    stop.to_name = trip.departs_to
    stop.from_name = trip.departs_from
    stop.save
  end
  
  def parse_airport_to_name
    to_iata = self.to_name.split("-")[0].strip.upcase
    to_name = self.to_name.split("-")[1].strip
    if to_iata.length == 3
      self.to_iata = to_iata
      self.to_name = to_name
      self.save
    end
  end
  
  def parse_airport_from_name
    from_iata = self.from_name.split("-")[0].strip.upcase
    from_name = self.from_name.split("-")[1].strip
    if from_iata.length == 3
      self.from_iata = from_iata
      self.from_name = from_name
      self.save
    end
  end
  
  
end
