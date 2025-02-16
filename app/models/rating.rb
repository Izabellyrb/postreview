class Rating < ApplicationRecord
  validates :value, presence: true, inclusion: { in: 1..5 }

  belongs_to :post
  belongs_to :user
end
