class Problem < ApplicationRecord
  belongs_to :user
  has_many :inputs
  has_attached_file :image, styles: { medium: "700x480>", thumb: "100x100>" },
    default_url: "workshop-img-2.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
