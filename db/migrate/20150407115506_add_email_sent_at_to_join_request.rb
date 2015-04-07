class AddEmailSentAtToJoinRequest < ActiveRecord::Migration
  def change
    add_column :join_requests, :new_email_sent_at, :datetime
    add_column :join_requests, :accepted_email_sent_at, :datetime
    add_column :messages, :email_sent_at, :datetime
  end
end
