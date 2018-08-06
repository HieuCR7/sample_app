class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.maximum}
  validate  :picture_size

  private

  def picture_size
    add_errors if picture.size > Settings.micropost.size_picture.megabytes
  end

  def add_errors
    errors.add(:picture, t(".size_too_large"))
  end
end
