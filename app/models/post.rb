class Post < ApplicationRecord
  validates :title, :body, :ip, presence: true
  validates :ip, format: { with: (Resolv::IPv4::Regex || Resolv::IPv6::Regex),
                           message: I18n.t("activerecord.messages.invalid_ip") }
  belongs_to :user
  has_many :ratings, dependent: :destroy
end
