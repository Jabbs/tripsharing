class StaticPagesController < ApplicationController
  
  def home
    # @fb_images_rand_5 = User.fb_image_random_5
    # @pete = User.find_by_email("petejabbour1@gmail.com")
    # @pete_rand5 = @pete.facebook_friends_photos_rand5
    @session_user = User.new
    @user = User.new
    redirect_to trips_path if current_user
  end
  
  def about
    @fb_images_rand_5 = User.fb_image_random_5
  end
  
  def how_it_works
  end
  
  def privacy
  end
  
  def terms
  end
  
  def press
  end
  
  def unsubscribed
  end
end
