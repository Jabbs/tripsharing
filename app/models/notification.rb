class Notification < ActiveRecord::Base
  belongs_to :user
  
  # after_create :send_email
  
  def self.add_to(user, trigger_code)
    user.notifications.create!(trigger_code: trigger_code)
  end
  # 
  # def send_email
  #   unless self.email_sent?
  #     case self.trigger_code
  #     when "A"
  #     when "B"
  #     when "C"
  #     when "D"
  #       
  #     when "E"
  #     when "F"
  #     when "G"
  #     when "H"
  #     when "I"
  #     when "J"
  #     when "K"
  #     when "L"
  #     when "M"
  #     when "N"
  #     when "O"
  #     when "P"
  #     when "Q"
  #     end
  #   end
  # end
  
  # T-Triggers (external)
  #   Types
  #     e=email
  #     n=notification
  #     f=feed-item
  #   Format
  #     ID-timing-context-name-type-type-type
  #   General
  #     A-immediate-user-verification-e
  #   Trip
  #     B-daily-trips-newsletter-e
  #     C-weekly-trips-newsletter-e
  #     D-immediate-trip-creation-e-n-f
  #     E-immediate-trip-join-request-creation-e-n
  #     F-immediate-trip-join-accepted-e-n
  #     G-immediate-trip-join-denied
  #     H-immediate-trip-departing-last-call-e-n
  #     I-immediate-trip-departing-soon-e-n
  #     J-immediate-trip-starting-e-n-f
  #     K-immediate-trip-complete-e-n-f
  #     L-lagging-trip-stop-crud-n
  #     M-lagging-trip-timing-changes-e-n
  #     N-lagging-trip-following-n
  #   Message
  #     O-immediate-message-creation-e-n
  #   User
  #     P-lagging-following-creation-e-n-f
  #     Q-immediate-user-creation-f
  #   Comment
  #     R-immediate-comment-creation-e-n
  

end
