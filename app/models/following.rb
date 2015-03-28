class Following < ActiveRecord::Base
  
  # associations
  belongs_to :user
  belongs_to :followable, polymorphic: true, counter_cache: true
  
  # validations
  validates :user_id, presence: true, uniqueness: { scope: [:followable_id, :followable_type] }
  validates :followable_id, presence: true
  validates :followable_type, presence: true
end
