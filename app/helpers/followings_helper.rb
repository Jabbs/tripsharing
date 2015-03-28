module FollowingsHelper
  
  def current_user_following?(item)
    if current_user && item.followings.where(user_id: current_user.id).any?
      true
    else
      false
    end
  end
end
