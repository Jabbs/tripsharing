class Interest < ActiveRecord::Base
  attr_accessible :identifier, :user_id, :category
  
  belongs_to :user
  
  validates :user_id, presence: true
  validates :identifier, presence: true, uniqueness: { scope: [:user_id] }
  
  IDS = [
    ["Location", ["1","2"]],
    ["Duration", ["3","4","5"]],
    ["Time of Year", ["6","7","8","9"]],
    ["Group Dynamics", ["10","11"]],
    ["General", ["12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"]]
  ]
  
  IDENTIFIERS = {
    '1' => 'International',
    '2' => 'Local',
    '3' => 'Weekend Trips',
    '4' => 'Week Long',
    '5' => 'Month(s)',
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
