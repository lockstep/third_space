class Problem < ApplicationRecord
  belongs_to :user
  has_many :inputs
  has_many :comments

  def get_len_value(len_type)
    len = inputs.find_by(lens: len_type)
    len ? len.input_text : ''
  end
end
