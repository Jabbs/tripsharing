class Message < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: :sender_id
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  
  validates :content, presence: true
  validates :receiver_id, presence: true
  validates :sender_id, presence: true
  
  # scopes
  scope :unviewed, ->() { where(viewed: false) }
  
  def view_message
    self.viewed = true
    save
  end
  
  def unread?
    self.viewed == true ? false : true
  end
end
