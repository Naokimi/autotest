class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :submission
  has_one :exam, through: :question
end
