class User < ApplicationRecord
  VALID_EMAIL_REGEX = Regexp.new(Settings.users.EMAIL_REGEX)

  validates :name, presence: true,
  length: {maximum: Settings.users.name_maximum}
  validates :email, presence: true,
  length: {maximum: Settings.users.email_maximum},
  format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  before_save :downcase_email

  has_secure_password

  private
  def downcase_email
    email.downcase!
  end
end
