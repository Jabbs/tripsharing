OmniAuth.config.logger = Rails.logger

# removed "user_groups", "user_photos" on 4/9/15
# removed "user_interests" on 4/9/15 bc it is depreciating in June (was a subset of user_likes)
# removed "user_tagged_places" on 5/1/15
# removed "friends_photos" on 5/5/15
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'],
           scope: 'email, user_birthday, user_hometown, user_location'
end
