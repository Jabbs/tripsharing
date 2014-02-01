class TripApplication < ActiveRecord::Base
  attr_accessible :introduction, :status, :trip_id, :user_id
end
