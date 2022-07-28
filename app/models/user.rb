class User < ApplicationRecord
  UPDATETABLE_ATTRS = %i(name email password password_confirmation).freeze

  before_save :downcase_email

  validates :name, presence: true,
            length: {maximum: Settings.user.NAME_MAX_LENGTH}
  validates :email, presence: true,
            length: {minimum: Settings.user.EMAIL_MIN_LENGTH,
                     maximum: Settings.user.EMAIL_MAX_LENGTH},
            format: {with: Settings.user.VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true,
            length: {minimum: Settings.user.PASSWORD_MIN_LENGTH}, if: :password
  has_secure_password

  private
  def downcase_email
    email.downcase!
  end
end
