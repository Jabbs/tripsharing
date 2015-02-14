class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: [:slugged, :history]
  has_secure_password
  
  # associations
  has_many :trips
  has_many :interests, dependent: :destroy
  has_one :survey
  
  # callbacks
  before_create { generate_token(:auth_token) }
  before_save :correct_case_of_inputs
  # after_commit :send_verification_email, on: :create
  after_commit :build_interests
  
  # validations
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, :with => /@/
  validates :password, presence: true, on: :create, :length => { :minimum => 5 }
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
      user.birth_year = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y').year if auth.extra.raw_info.birthday
      user.birthday = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y') if auth.extra.raw_info.birthday
      user.verified = auth.info.verified
      user.gender = auth.extra.raw_info.gender
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
    self.first_name + " " + self.last_name
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
