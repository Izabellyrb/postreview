class Rating < ApplicationRecord
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :user_id, uniqueness: { scope: :post_id, message: I18n.t("activerecord.messages.single_vote") }

  belongs_to :post
  belongs_to :user
end
