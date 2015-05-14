class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notificationable, polymorphic: true
  
  # scopes
  scope :unviewed, ->() { where(viewed: false) }
  scope :with_badges_unviewed, ->() { where(badge_viewed: false) }
  
  validates :user_id, presence: true
  validates :trigger_code, presence: true
  validates :notificationable_id, presence: true
  validates :notificationable_type, presence: true
  validates_uniqueness_of :user_id, scope: [:trigger_code, :notificationable_id, :notificationable_type]
  
  def self.add_to(user, trigger_code, notificationable)
    user.notifications.create(trigger_code: trigger_code, notificationable: notificationable)
  end
  
  # FUNCTIONAL:
  # A-immediate-user-verification-e
  # F-immediate-trip-creation-e-n-f
  # G-immediate-trip-join-request-creation-e-n
  # H-immediate-trip-join-accepted-e-n
  # Q-immediate-message-creation-e-n
  
  # T-Triggers (external)
  #   Types
  #     e=email
  #     m=message
  #     n=notification
  #     f=feed-item
  #   Format
  #     ID-timing-context-name-type-type-type
  #   General
  #     A-immediate-user-verification-e
  #     B-immediate-user-announcements-updates-e
  #     C-immediate-user-announcements-travel-tips-e
  #   Trip
  #     D-daily-trips-newsletter-e
  #     E-weekly-trips-newsletter-e
  #     F-immediate-trip-creation-e-f
  #     G-immediate-trip-join-request-creation-e-m
  #     H-immediate-trip-join-accepted-e-n
  #     I-immediate-trip-join-denied
  #     J-immediate-trip-departing-soon-e-n
  #     K-immediate-trip-starting-e-n-f
  #     L-immediate-trip-complete-e-n-f
  #     M-immediate-trip-stop-crud-n
  #     N-immediate-trip-timing-changes-e-n
  #     O-immediate-trip-following-n-f
  #   Message
  #     P-immediate-message-creation-e-m
  #   User
  #     Q-immediate-following-creation-n-f
  #     R-immediate-user-creation-f

  

end
