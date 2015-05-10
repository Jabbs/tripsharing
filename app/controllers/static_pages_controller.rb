class StaticPagesController < ApplicationController
  before_filter :load_users
  
  def home
    # @fb_images_rand_5 = User.fb_image_random_5
    # @pete = User.find_by_email("petejabbour1@gmail.com")
    # @pete_rand5 = @pete.facebook_friends_photos_rand5
    redirect_to root_path
  end
  
  def home2
  end
  
  def about
    @fb_images_rand_5 = User.fb_image_random_5
  end
  
  # def old_about
  #   @fb_images_rand_5 = User.fb_image_random_5
  # end
  
  def how_it_works
    redirect_to root_path
  end
  
  def privacy
  end
  
  def terms
  end
  
  def press
    redirect_to root_path
  end
  
  def contact_us
    redirect_to root_path
  end
  
  def unsubscribed
  end
  
  private
  
    def load_users
      @session_user = User.new
      @user = User.new
    end
end
