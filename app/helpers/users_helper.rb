module UsersHelper
  
  def image(user)
    if user.fb_image.present?
      image_tag @trip.user.fb_image
  	else
  		image_tag "default_profile_image.png"
  	end
  end
  
  def user_profile_image(user, size)
    case size
    when "normal"
      size = "110x110"
      fb_type = "normal"
      attch_size = :small
    when "large"
      size = "210x210"
      fb_type = "large"
      attch_size = :small
    end
    
    if user.image_attachments.count != 0
      img_path = user.image_attachments.last.image.url(attch_size)
    elsif user.fb_image.present? 
      img_path = "#{user.fb_image}" + "?type=#{fb_type}" 
    else 
      img_path = "default_profile_image.png" 
    end 
    return image_tag(img_path, class: "profile-pic img-responsive", size: size, title: user.full_name).to_s
  end
  
  def user_image(user)
    if user.image_attachments.count != 0 
      img_path = image_path(user.image_attachments.last.image.url(:thumb)).to_s 
    elsif user.fb_image.present? 
      img_path = "#{user.fb_image}" + "?type=small"  
    else
      img_path = "default_profile_image.png"
		end
    return image_tag(img_path, class: "image", title: user.full_name, size: "50x50") 
  end
  
  def user_details(user)
    content_tag(:ul, class: 'list-unstyled') do
      content_tag(:li, user.full_name) +
      content_tag(:li, "#{user.age}, #{user.gender.capitalize}") + 
      content_tag(:li, user.try(:location))
    end
  end
end
