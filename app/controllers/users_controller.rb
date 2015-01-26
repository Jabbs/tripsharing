class UsersController < ApplicationController
  # before_filter :signed_in_user, only: [:show]
  
  def home
    @fb_images_rand_5 = User.fb_image_random_5
    # @pete = User.find_by_email("petejabbour1@gmail.com")
    # @pete_rand5 = @pete.facebook_friends_photos_rand5
  end
  
  def profile
    
  end
  
  def browse
    
  end
end
