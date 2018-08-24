class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.maximum}
  validate  :picture_size

  default_scope ->{order(created_at: :desc)}
  scope :by_user_id, ->(id){where user_id: id}
  scope :by_follow, ->(following_ids, id){where("user_id IN (?) OR user_id = ?", following_ids, id)}

  private

  def picture_size
    return unless picture.size > Settings.micropost.size_picture.megabytes
    errors.add(:picture, t(".size_too_large"))
  end
end
