class Comment < ApplicationRecord
  belongs_to :problem
  belongs_to :user

  validates :description, presence: true
end
