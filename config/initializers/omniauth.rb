OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'],
           scope: 'email, user_birthday, user_hometown, user_location,
           user_groups, user_interests, user_likes, user_photos, friends_photos'
end
