desc "Creates notifications and feed items"
task :send_notifications => :environment do
  
  Activity.where(notifications_sent: false).each do |activity|
    activity.send_notifications
  end
  
  
end