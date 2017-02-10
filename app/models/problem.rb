class Problem < ApplicationRecord
  belongs_to :user
  has_many :inputs
  has_many :comments

  def get_lense_value(lense_type)
    lense = inputs.find_by(lens: lense_type)
    lense ? lense.input_text : ''
  end
end
