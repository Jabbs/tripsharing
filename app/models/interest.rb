class Interest < ActiveRecord::Base
  attr_accessible :identifier, :user_id, :category
  
  belongs_to :user
  
  validates :user_id, presence: true
  validates :identifier, presence: true, uniqueness: { scope: [:user_id] }
  
  IDS = [
    ["Destination", ["1","2","3","4","5","6","7","8","9","10"]],
    ["Duration", ["11","12","13","14","15"]],
    ["Time of Year", ["16","17","18","19","20","21"]],
    ["Group Dynamics", ["22","23","24","25","26","27"]],
    ["General", ["28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44"]]
  ]
  
  IDENTIFIERS = {
    '1' => 'Near Me / Locally',
    '2' => 'Internationally',
    '3' => 'Europe',
    '4' => 'Africa',
    '5' => 'East Asia and the Pacific',
    '6' => 'South Asia',
    '7' => 'Middle East',
    '8' => 'N. America',
    '9' => 'S. America',
    '10' => 'Central America',
    '11' => 'For a weekend',
    '12' => 'For a full week',
    '13' => 'Month(s)',
    '14' => 'Indefinately',
    '15' => 'I dont travel with a schedule',
    '16' => 'Spring',
    '17' => 'Summer',
    '18' => 'Fall',
    '19' => 'Winter',
    '20' => 'When its cold by me',
    '21' => 'When its hot by me',
    '22' => 'Singles (near my hometown)',
    '23' => 'Singles (from my country)',
    '24' => 'Singles (international)',
    '25' => 'Couples (near my hometown)',
    '26' => 'Couples (from my country)',
    '27' => 'Couples (international)',
    '28' => 'Partying / Clubbing',
    '29' => 'Exploring the city',
    '30' => 'Sports',
    '31' => 'Cultural immersion',
    '32' => 'Backpacking',
    '33' => 'Bicycling',
    '34' => 'Overland and Safari',
    '35' => 'Mountaineering',
    '36' => 'Sailing / Boating',
    '37' => 'Scuba / Snorkelling',
    '38' => 'Skiing',
    '39' => 'Trekking / Hiking',
    '40' => 'Business / Networking',
    '41' => 'Volunteering',
    '42' => 'Wildlife / Ecology',
    '43' => 'Food / Wine',
    '44' => 'Drinking with locals'
  }
  
end
