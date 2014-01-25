class VerificationWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: true, retry: 3

  def perform(user_id)
    user = User.find_by_id(user_id)
    user.generate_token(:verification_token)
    user.save
    unless user.verification_sent_at
      UserMailer.verification_email(user).deliver
      user.verification_sent_at = Time.zone.now
      user.save
    end
  end
end