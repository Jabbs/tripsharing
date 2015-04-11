class Stop < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user
  
  after_create :parse_airport_to_name
  after_create :parse_airport_from_name
  
  TRANSPORTATION_TYPES = {"1" => "flight", "2" => "car"}
  TRANSPORTATION_TYPES_ARRAY = [["flight", "1"], ["car", "2"]]
  
  def self.create_from_trip(trip)
    if !trip.stop_location.blank?
      stop = trip.stops.new(user_id: trip.user_id)
      stop.to_name = trip.stop_location
      # stop.to_name_dest = trip.stop_location
      stop.to_date = trip.departs_at if trip.departs_at
      stop.save
    end
  end
  
  def parse_airport_to_name
    to_iata = self.to_name.split("-")[0].strip.upcase  if self.to_name.split("-")[0].present?
    to_name = self.to_name.split("-")[1].strip if self.to_name.split("-")[1].present?
    if to_iata != nil && to_name != nil && to_iata.length == 3
      self.to_iata = to_iata
      self.to_name = to_name
      self.save
    end
  end
  
  def parse_airport_from_name
    if self.from_name.present?
      from_iata = self.from_name.split("-")[0].strip.upcase
      from_name = self.from_name.split("-")[1].strip
      if from_iata.length == 3
        self.from_iata = from_iata
        self.from_name = from_name
        self.save
      end
    end
  end
  
  
end
