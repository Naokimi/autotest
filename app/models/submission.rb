class Submission < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy
  mount_uploader :image, ImageUploader

  def score
    self.answers.where('is_correct = true').count
  end
end
