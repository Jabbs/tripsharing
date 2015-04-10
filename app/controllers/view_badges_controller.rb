class ViewBadgesController < ApplicationController
  before_filter :signed_in_user
  
  def viewed_message_badges
    @join_requests_received.update_all(badge_viewed: true)
    @received_messages.update_all(badge_viewed: true)
  end
  
  def viewed_notification_badges
    @new_notifications.update_all(badge_viewed: true)
  end
end
