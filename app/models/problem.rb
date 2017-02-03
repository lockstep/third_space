class Problem < ApplicationRecord
  belongs_to :user
  has_many :inputs
  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
