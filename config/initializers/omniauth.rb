OmniAuth.config.logger = Rails.logger

# removed "user_groups", "user_photos" on 4/9/15
# removed "user_interests" on 4/9/15 bc it is depreciating in June (was a subset of user_likes)
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'],
           scope: 'email, user_birthday, user_hometown, user_location,
           friends_photos, user_tagged_places'
end
