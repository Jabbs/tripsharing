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
