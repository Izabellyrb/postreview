class User < ApplicationRecord
  validates :login, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :posts, dependent: :destroy
  has_many :ratings, dependent: :destroy
end
