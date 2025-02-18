class Rating < ApplicationRecord
  validates :user_id, uniqueness: { scope: :post_id, message: I18n.t("activerecord.messages.single_vote") }
  validates :value, presence: true, numericality: { only_integer: true,
                                                    greater_than_or_equal_to: 1,
                                                    less_than_or_equal_to: 5 }

  belongs_to :post
  belongs_to :user
end
