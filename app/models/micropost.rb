class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  CREATEABLE_ATTRS = %i(content picture).freeze

  validates :content, presence: true,
            length: {maximum: Settings.micropost.CONTENT_MAX_LENGTH}

  delegate :name, to: :user, prefix: true

  scope :newest, ->{order created_at: :desc}
  scope :by_user_id, ->(user_id){where("user_id = ?", user_id)}
end
