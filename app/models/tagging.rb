class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, polymorphic: true
  
  validates :tag_id, presence: true, uniqueness: { scope: [:taggable_type, :taggable_id] }

end
