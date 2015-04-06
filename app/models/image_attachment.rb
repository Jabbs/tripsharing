class ImageAttachment < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :image_attachable, polymorphic: true
  mount_uploader :image, ImageUploader
  
  # validations
  validates :image, presence: true
  validates :image_attachable_id, presence: true
  validates :image_attachable_type, presence: true
end
