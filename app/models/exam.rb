class Exam < ApplicationRecord
  belongs_to :teacher
  has_many :questions, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :answers, through: :submissions

  mount_uploader :image, ImageUploader

  validates :image, :teacher_id, presence: true

  def average_score
    return 0 if submissions.empty?

    sum = 0.0
    submissions.each do |submission|
      sum += submission.score
    end
    return (sum / submissions.count).floor(1)
  end

  def average_percentage
    return 0 if submissions.empty?

    (average_score / questions.count * 100).round
  end

  def highest_score
    return 0 if submissions.empty?

    scores = []
    submissions.each do |submission|
      scores << submission.score
    end
    scores.max
  end

  def lowest_score
    return 0 if submissions.empty?

    scores = []
    submissions.each do |submission|
      scores << submission.score
    end
    scores.min
  end


end
