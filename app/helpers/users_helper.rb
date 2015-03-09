module UsersHelper
  
  def image(user)
    if user.fb_image.present?
      image_tag @trip.user.fb_image
  	else
  		image_tag "blank_avatar.png"
  	end
  end
end
