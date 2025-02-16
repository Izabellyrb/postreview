class Post < ApplicationRecord
  validates :title, :body, :ip, presence: true

  belongs_to :user
  has_many :ratings, dependent: :destroy
end
