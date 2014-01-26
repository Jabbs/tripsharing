class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, use: [:slugged, :history]
  attr_accessible :admin, :auth_token, :birth_year, :email, :fb_hometown, :fb_image, :fb_location, 
                  :fb_url, :first_name, :gender, :last_name, :last_sign_in_at, :last_sign_in_ip, :newsletter, 
                  :oauth_expires_at, :oauth_token, :password_digest, :password_reset_sent_at, 
                  :password_reset_token, :phone, :sign_in_count, :slug, :subscribed, :uid, :verification_sent_at, 
                  :verification_token, :verified
  has_secure_password
  
  # associations
  
  # callbacks
  before_create { generate_token(:auth_token) }
  before_save :correct_case_of_inputs
  after_commit :send_verification_email, on: :create
  
  # validations
  validates :email, presence: true, uniqueness: true
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
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.birth_year = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y').year if auth.extra.raw_info.birthday
      user.verified = auth.info.verified
      user.gender = auth.extra.raw_info.gender
      user.newsletter = true
      user.password = SecureRandom.urlsafe_base64
      logger.debug "%%%%%%%%%%% AUTH: #{auth}"
      logger.debug "%%%%%%%%%%% PHOTO???: #{auth.extra}"
      user.save!
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
