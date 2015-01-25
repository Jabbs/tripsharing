class Interest < ActiveRecord::Base
  attr_accessible :identifier, :user_id
  
  belongs_to :user
  
  validates :user_id, presence: true
  validates :identifier, presence: true, uniqueness: { scope: [:user_id] }
  
  IDENTIFIERS = {
    '1' => 'International Trips',
    '2' => 'Local Trips',
    '3' => 'Weekend',
    '4' => 'Week',
    '5' => 'Freeloader',
    '6' => 'Spring',
    '7' => 'Summer',
    '8' => 'Fall',
    '9' => 'Winter',
    '10' => 'Singles',
    '11' => 'Couples',
    '12' => 'Partying/Clubbing',
    '13' => 'Explore City',
    '14' => 'Sports',
    '15' => 'Cultural Immersion',
    '16' => 'Backpacking',
    '17' => 'Bicycling',
    '18' => 'Overland and Safari',
    '19' => 'Mountaineering',
    '20' => 'Sailing / Boating',
    '21' => 'Scuba / Snorkelling',
    '22' => 'Skiing',
    '23' => 'Trekking / Hiking',
    '24' => 'Business/Networking',
    '25' => 'Volunteering',
    '26' => 'Wildlife / Ecology',
    '27' => 'Food/Wine'
  }
  
end
