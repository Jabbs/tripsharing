desc "Tracks users daily activity with a 0 for inactive and a 1 for active."
task :track_daily_activity => :environment do
  User.find_each do |user|
  	if user.last_sign_in_at.nil?
  		user.activity_trail += "0"
  	elsif user.last_sign_in_at > 24.hour.ago
  		user.activity_trail += "1"
    else
  		user.activity_trail += "0"
  	end
  	user.save
  end
end

task :count_daily_active_users => :environment do
  report = Report.new
  report.daily_active_user_count = User.where("last_sign_in_at > ?", DateTime.now - 24.hours).count
  report.save
end
