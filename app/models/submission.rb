class Submission < ApplicationRecord
  belongs_to :exam
  has_many :answers, dependent: :destroy
  mount_uploader :image, ImageUploader
end
