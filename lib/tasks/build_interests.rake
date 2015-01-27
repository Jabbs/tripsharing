desc "Creates interests for all users"
task :build_interests => :environment do
  User.all.each do |user|
    Interest::IDS.each do |identifier_group|
      identifier_group[1].each do |identifier|
        user.interests.create!(identifier: identifier, category: identifier_group[0])
      end
    end
  end
end

