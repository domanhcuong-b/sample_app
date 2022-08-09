class User < ApplicationRecord
  UPDATETABLE_ATTRS = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token

  before_save :downcase_email

  validates :name, presence: true,
            length: {maximum: Settings.user.NAME_MAX_LENGTH}
  validates :email, presence: true,
            length: {minimum: Settings.user.EMAIL_MIN_LENGTH,
                     maximum: Settings.user.EMAIL_MAX_LENGTH},
            format: {with: Settings.user.VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true, allow_nil: true,
            length: {minimum: Settings.user.PASSWORD_MIN_LENGTH}
  has_secure_password

  scope :order_by_time_created, ->{order created_at: :desc}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def authenticated? remember_token
    return false unless remember_token

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  def downcase_email
    email.downcase!
  end
end
