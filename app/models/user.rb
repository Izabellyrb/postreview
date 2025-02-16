class User < ApplicationRecord
  validates :login, uniqueness: true, presence: true, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: I18n.t("activerecord.messages.invalid_login")
  }

  has_many :posts, dependent: :destroy
  has_many :ratings, dependent: :destroy
end
