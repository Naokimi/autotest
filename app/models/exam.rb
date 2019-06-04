class Exam < ApplicationRecord
  belongs_to :teacher
  has_many :questions, dependent: :destroy
  has_many :submissions, dependent: :destroy
  mount_uploader :image, ImageUploader

  validates :image, :teacher_id, presence: true
end
