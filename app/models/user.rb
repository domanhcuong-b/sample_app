class User < ApplicationRecord
  UPDATETABLE_ATTRS = %i(name email password password_confirmation).freeze
  RESET_PASSWORD_ATTRS = %i(password password_confirmation).freeze
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.blank?

    BCrypt::Password.new(digest).is_password? token
  end

  def send_mail_activate
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.email.TIME_EXPIRE_PASSWORD_RESET.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
