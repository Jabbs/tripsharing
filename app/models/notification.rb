class Notification < ActiveRecord::Base
  belongs_to :user
  
  def self.add_to(user, trigger_code)
    user.notifications.create!(trigger_code: trigger_code)
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
  #     F-immediate-trip-creation-e-n-f
  #     G-immediate-trip-join-request-creation-e-n
  #     H-immediate-trip-join-accepted-e-n
  #     I-immediate-trip-join-denied
  #     J-immediate-trip-departing-soon-e-n
  #     K-immediate-trip-starting-e-n-f
  #     L-immediate-trip-complete-e-n-f
  #     M-lagging-trip-stop-crud-n
  #     N-lagging-trip-timing-changes-e-n
  #     O-lagging-trip-following-n
  #   Message
  #     P-immediate-message-creation-e-n
  #   User
  #     Q-lagging-following-creation-e-n-f
  #     R-immediate-user-creation-f

  

end
