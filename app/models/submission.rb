class Submission < ApplicationRecord
  belongs_to :exam
  mount_uploader :image, ImageUploader
end
