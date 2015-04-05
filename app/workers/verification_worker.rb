class VerificationWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: true, retry: 3, failures: :exhausted

  def perform(user_id)
    user = User.find_by_id(user_id)
    user.generate_token(:verification_token)
    user.save
    unless user.verification_sent_at && user.verification_sent_at > 10.minute.ago
      UserMailer.verification_email(user).deliver
    end
  end
  
  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end
end