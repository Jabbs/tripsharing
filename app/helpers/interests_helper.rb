module InterestsHelper
  
  def has_interest?(identifier)
    interests = current_user.interests.where(identifier: identifier)
    interests.any? ? true : false
  end
end
