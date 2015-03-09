class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: [:slugged, :history]
  has_secure_password
  FACES = ["calebogden","adellecharles","pixeliris","boheme","michzen","madedigital","geeftvorm","jennyshen","alv",
    "chloepark","lovskogen","teylorfeliz","nickcouto","jobharmsen","hollowellme","heyjoyhey","zwitscherlise","visionarty","shibu_ravi",
    "kfriedson","edwellbrook","mikaelstaer", "gigifk", "leezlee", "calebjoyce", "karagates", "cheriana", "her_ruu",
    "beliv", "kennedysgarage","lady_katherine","tomsturge","dingledow","hannahlikesyouu","4l3d",
    "romanbulah","rdsaunders", "kennahasson", "leez", "katelynannsays", "aiiaiiaii", "slowspock", "websiddu",
    "paladinstudio", "tal_hertz","knilob", "doesmostthings","maridlcrmn", "simplyand", "chloepark", "dwaldron", "chexee",
    "oykun", "mcercos"]
  
  #   Mapping from select array to the hash:
  #   a = User::NATIONALITIES_ARRAY
  #   b = a.map { |x| "#{x[1]}"+ "monkey" + " => " + "monkey" + x[0] }
  #   find and replace "monkey" with: "
  
  NATIONALITIES = {"0" => "any", "1" => "American", "2" => "British", "3" => "English", "4" => "Irish", "5" => "Northern Irish", "6" => "Canadian", 
    "7" => "Scottish", "8" => "Welsh", "9" => "Australian", "10" => "Afghan", "11" => "Albanian", "12" => "Algerian", "13" => "Andorran", 
    "14" => "Angolan", "15" => "Antiguans", "16" => "Argentinean", "17" => "Armenian", "18" => "Austrian", "19" => "Azerbaijani", "20" => "Bahamian", 
    "21" => "Bahraini", "22" => "Bangladeshi", "23" => "Barbadian", "24" => "Barbudans", "25" => "Batswana", "26" => "Belarusian", "27" => "Belgian", 
    "28" => "Belizean", "29" => "Beninese", "30" => "Bhutanese", "31" => "Bolivian", "32" => "Bosnian", "33" => "Brazilian", "34" => "Bruneian", 
    "35" => "Bulgarian", "36" => "Burkinabe", "37" => "Burmese", "38" => "Burundian", "39" => "Cambodian", "40" => "Cameroonian", "41" => "Cape Verdean", 
    "42" => "Central African", "43" => "Chadian", "44" => "Chilean", "45" => "Chinese", "46" => "Colombian", "47" => "Comoran", "48" => "Congolese", 
    "49" => "Congolese", "50" => "Costa Rican", "51" => "Croatian", "52" => "Cuban", "53" => "Cypriot", "54" => "Czech", "55" => "Danish", 
    "56" => "Djibouti", "57" => "Dominican", "58" => "Dutch", "59" => "Dutchman", "60" => "Dutchwoman", "61" => "East Timorese", "62" => "Ecuadorean", 
    "63" => "Egyptian", "64" => "Emirian", "65" => "Equatorial Guinean", "66" => "Eritrean", "67" => "Estonian", "68" => "Ethiopian", "69" => "Fijian", 
    "70" => "Filipino", "71" => "Finnish", "72" => "French", "73" => "Gabonese", "74" => "Gambian", "75" => "Georgian", "76" => "German", "77" => "Ghanaian", 
    "78" => "Greek", "79" => "Grenadian", "80" => "Guatemalan", "81" => "Guinea-Bissauan", "82" => "Guinean", "83" => "Guyanese", "84" => "Haitian", 
    "85" => "Herzegovinian", "86" => "Honduran", "87" => "Hungarian", "88" => "I-Kiribati", "89" => "Icelander", "90" => "Indian", "91" => "Indonesian", 
    "92" => "Iranian", "93" => "Iraqi", "94" => "Israeli", "95" => "Italian", "96" => "Ivorian", "97" => "Jamaican", "98" => "Japanese", "99" => "Jordanian", 
    "100" => "Kazakhstani", "101" => "Kenyan", "102" => "Kittian and Nevisian", "103" => "Kuwaiti", "104" => "Kyrgyz", "105" => "Laotian", 
    "106" => "Latvian", "107" => "Lebanese", "108" => "Liberian", "109" => "Libyan", "110" => "Liechtensteiner", "111" => "Lithuanian", 
    "112" => "Luxembourger", "113" => "Macedonian", "114" => "Malagasy", "115" => "Malawian", "116" => "Malaysian", "117" => "Maldivan", "118" => "Malian", 
    "119" => "Maltese", "120" => "Marshallese", "121" => "Mauritanian", "122" => "Mauritian", "123" => "Mexican", "124" => "Micronesian", "125" => "Moldovan", 
    "126" => "Monacan", "127" => "Mongolian", "128" => "Moroccan", "129" => "Mosotho", "130" => "Motswana", "131" => "Mozambican", "132" => "Namibian", 
    "133" => "Nauruan", "134" => "Nepalese", "135" => "Netherlander", "136" => "New Zealander", "137" => "Ni-Vanuatu", "138" => "Nicaraguan", 
    "139" => "Nigerian", "140" => "Nigerien", "141" => "North Korean", "142" => "Norwegian", "143" => "Omani", "144" => "Pakistani", "145" => "Palauan", 
    "146" => "Panamanian", "147" => "Papua New Guinean", "148" => "Paraguayan", "149" => "Peruvian", "150" => "Polish", "151" => "Portuguese", 
    "152" => "Qatari", "153" => "Romanian", "154" => "Russian", "155" => "Rwandan", "156" => "Saint Lucian", "157" => "Salvadoran", "158" => "Samoan", 
    "159" => "San Marinese", "160" => "Sao Tomean", "161" => "Saudi", "162" => "Senegalese", "163" => "Serbian", "164" => "Seychellois", 
    "165" => "Sierra Leonean", "166" => "Singaporean", "167" => "Slovakian", "168" => "Slovenian", "169" => "Solomon Islander", "170" => "Somali", 
    "171" => "South African", "172" => "South Korean", "173" => "Spanish", "174" => "Sri Lankan", "175" => "Sudanese", "176" => "Surinamer", 
    "177" => "Swazi", "178" => "Swedish", "179" => "Swiss", "180" => "Syrian", "181" => "Taiwanese", "182" => "Tajik", "183" => "Tanzanian", "184" => "Thai", 
    "185" => "Tobagonian", "186" => "Togolese", "187" => "Tongan", "188" => "Trinidadian", "189" => "Tunisian", "190" => "Turkish", "191" => "Tuvaluan", 
    "192" => "Ugandan", "193" => "Ukrainian", "194" => "Uruguayan", "195" => "Uzbekistani", "196" => "Venezuelan", "197" => "Vietnamese", "198" => "Yemenite", 
    "199" => "Zambian", "200" => "Zimbabwean"}
  NATIONALITIES_ARRAY = [["any", "0"], ["American", "1"], ["British", "2"], ["English", "3"], ["Irish", "4"], ["Northern Irish", "5"], ["Canadian", "6"], 
    ["Scottish", "7"], ["Welsh", "8"], ["Australian", "9"], ["Afghan", "10"], ["Albanian", "11"], ["Algerian", "12"], ["Andorran", "13"], 
    ["Angolan", "14"], ["Antiguans", "15"], ["Argentinean", "16"], ["Armenian", "17"], ["Austrian", "18"], ["Azerbaijani", "19"], 
    ["Bahamian", "20"], ["Bahraini", "21"], ["Bangladeshi", "22"], ["Barbadian", "23"], ["Barbudans", "24"], ["Batswana", "25"], 
    ["Belarusian", "26"], ["Belgian", "27"], ["Belizean", "28"], ["Beninese", "29"], ["Bhutanese", "30"], ["Bolivian", "31"], ["Bosnian", "32"], 
    ["Brazilian", "33"], ["Bruneian", "34"], ["Bulgarian", "35"], ["Burkinabe", "36"], ["Burmese", "37"], ["Burundian", "38"], ["Cambodian", "39"], 
    ["Cameroonian", "40"], ["Cape Verdean", "41"], ["Central African", "42"], ["Chadian", "43"], ["Chilean", "44"], ["Chinese", "45"], 
    ["Colombian", "46"], ["Comoran", "47"], ["Congolese", "48"], ["Congolese", "49"], ["Costa Rican", "50"], ["Croatian", "51"], ["Cuban", "52"], 
    ["Cypriot", "53"], ["Czech", "54"], ["Danish", "55"], ["Djibouti", "56"], ["Dominican", "57"], ["Dutch", "58"], ["Dutchman", "59"], 
    ["Dutchwoman", "60"], ["East Timorese", "61"], ["Ecuadorean", "62"], ["Egyptian", "63"], ["Emirian", "64"], ["Equatorial Guinean", "65"], 
    ["Eritrean", "66"], ["Estonian", "67"], ["Ethiopian", "68"], ["Fijian", "69"], ["Filipino", "70"], ["Finnish", "71"], ["French", "72"], 
    ["Gabonese", "73"], ["Gambian", "74"], ["Georgian", "75"], ["German", "76"], ["Ghanaian", "77"], ["Greek", "78"], ["Grenadian", "79"], 
    ["Guatemalan", "80"], ["Guinea-Bissauan", "81"], ["Guinean", "82"], ["Guyanese", "83"], ["Haitian", "84"], ["Herzegovinian", "85"], 
    ["Honduran", "86"], ["Hungarian", "87"], ["I-Kiribati", "88"], ["Icelander", "89"], ["Indian", "90"], ["Indonesian", "91"], ["Iranian", "92"], 
    ["Iraqi", "93"], ["Israeli", "94"], ["Italian", "95"], ["Ivorian", "96"], ["Jamaican", "97"], ["Japanese", "98"], ["Jordanian", "99"], 
    ["Kazakhstani", "100"], ["Kenyan", "101"], ["Kittian and Nevisian", "102"], ["Kuwaiti", "103"], ["Kyrgyz", "104"], ["Laotian", "105"], 
    ["Latvian", "106"], ["Lebanese", "107"], ["Liberian", "108"], ["Libyan", "109"], ["Liechtensteiner", "110"], ["Lithuanian", "111"], 
    ["Luxembourger", "112"], ["Macedonian", "113"], ["Malagasy", "114"], ["Malawian", "115"], ["Malaysian", "116"], ["Maldivan", "117"], 
    ["Malian", "118"], ["Maltese", "119"], ["Marshallese", "120"], ["Mauritanian", "121"], ["Mauritian", "122"], ["Mexican", "123"], 
    ["Micronesian", "124"], ["Moldovan", "125"], ["Monacan", "126"], ["Mongolian", "127"], ["Moroccan", "128"], ["Mosotho", "129"], 
    ["Motswana", "130"], ["Mozambican", "131"], ["Namibian", "132"], ["Nauruan", "133"], ["Nepalese", "134"], ["Netherlander", "135"], 
    ["New Zealander", "136"], ["Ni-Vanuatu", "137"], ["Nicaraguan", "138"], ["Nigerian", "139"], ["Nigerien", "140"], ["North Korean", "141"], 
    ["Norwegian", "142"], ["Omani", "143"], ["Pakistani", "144"], ["Palauan", "145"], ["Panamanian", "146"], ["Papua New Guinean", "147"], 
    ["Paraguayan", "148"], ["Peruvian", "149"], ["Polish", "150"], ["Portuguese", "151"], ["Qatari", "152"], ["Romanian", "153"], ["Russian", "154"], 
    ["Rwandan", "155"], ["Saint Lucian", "156"], ["Salvadoran", "157"], ["Samoan", "158"], ["San Marinese", "159"], ["Sao Tomean", "160"], 
    ["Saudi", "161"], ["Senegalese", "162"], ["Serbian", "163"], ["Seychellois", "164"], ["Sierra Leonean", "165"], ["Singaporean", "166"], 
    ["Slovakian", "167"], ["Slovenian", "168"], ["Solomon Islander", "169"], ["Somali", "170"], ["South African", "171"], ["South Korean", "172"], 
    ["Spanish", "173"], ["Sri Lankan", "174"], ["Sudanese", "175"], ["Surinamer", "176"], ["Swazi", "177"], ["Swedish", "178"], ["Swiss", "179"], 
    ["Syrian", "180"], ["Taiwanese", "181"], ["Tajik", "182"], ["Tanzanian", "183"], ["Thai", "184"], ["Tobagonian", "185"], ["Togolese", "186"], 
    ["Tongan", "187"], ["Trinidadian", "188"], ["Tunisian", "189"], ["Turkish", "190"], ["Tuvaluan", "191"], ["Ugandan", "192"], ["Ukrainian", "193"], 
    ["Uruguayan", "194"], ["Uzbekistani", "195"], ["Venezuelan", "196"], ["Vietnamese", "197"], ["Yemenite", "198"], ["Zambian", "199"], 
    ["Zimbabwean", "200"]]
  
  # associations
  has_many :trips
  has_many :interests, dependent: :destroy
  has_many :join_requests, dependent: :destroy
  has_one :survey
  
  # callbacks
  before_create { generate_token(:auth_token) }
  before_save :correct_case_of_inputs
  # after_commit :send_verification_email, on: :create
  # after_commit :build_interests
  
  # validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true
  validates :birthday, presence: true
  validates_format_of :email, :with => /@/
  validates :password, presence: true, on: :create
  # validates_date :birthday, allow_blank: true
      
  
  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.fb_location = auth.info.location
      user.fb_hometown = auth.extra.raw_info.hometown.name if auth.extra.raw_info.hometown
      user.fb_image = auth.info.image
      user.fb_url = auth.info.urls.Facebook
      user.fb_locale = auth.extra.raw_info.locale
      user.fb_timezone = auth.extra.raw_info.timezone
      user.fb_updated_time = auth.extra.raw_info.updated_time
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.birthday = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y') if auth.extra.raw_info.birthday
      user.verified = auth.info.verified
      user.gender = auth.extra.raw_info.gender
      if auth.extra.raw_info.work
        auth.extra.raw_info.work.each do |employer|
          user.fb_occupation = employer.position.name unless employer.end_date.present?
        end
      end
      user.newsletter = true
      user.password = SecureRandom.urlsafe_base64
      logger.debug "%%%%%%%%%%% AUTH: #{auth}"
      user.save!
    end
  end
  
  def self.fb_image_random_5
    self.pluck(:fb_image).shuffle.first(5)
  end
  
  def age
    now = Time.now.utc.to_date
    now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
  end
  
  def build_interests
    Interest::IDS.each do |identifier_group|
      identifier_group[1].each do |identifier|
        self.interests.create!(identifier: identifier, category: identifier_group[0])
      end
    end
  end
  
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end
  
  def facebook_friends
    facebook { |fb| fb.get_connection("me", "friends") }
  end
  
  def facebook_friends_photos_rand5
    x = []
    5.times do
      x << self.facebook.get_picture(self.facebook_friends.shuffle.first['id'])
    end
    x
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def full_name
    self.first_name + " " + self.last_name if self.first_name && self.last_name
  end
  
  def correct_case_of_inputs
    self.email = self.email.strip.downcase
    self.first_name = self.first_name.strip
    self.last_name = self.last_name.strip
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset_email(self).deliver
  end
  
  def send_verification_email
    VerificationWorker.perform_async(self.id)
    # generate_token(:verification_token)
    # self.verification_sent_at = Time.zone.now
    # save!
    # UserMailer.verification_email(self).deliver
  end
end
