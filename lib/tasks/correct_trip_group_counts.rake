desc "Correct trip group_count"
task :correct_trip_group_counts => :environment do
  
  Trip.all.each do |trip|
    unless trip.group_count.nil?
      if trip.group_count == "1" || trip.group_count == "2" || trip.group_count == "3" || trip.group_count == "4"
        trip.group_count = "1"
        trip.save
      elsif trip.group_count == "5" || trip.group_count == "6"
        trip.group_count = "2"
        trip.save
      elsif trip.group_count == "7"
        trip.group_count = "3"
        trip.save
      elsif trip.group_count == "8"
        trip.group_count = "4"
        trip.save
      elsif trip.group_count == "9"
        trip.group_count = "5"
        trip.save
      end
    end
  end
  
  
end