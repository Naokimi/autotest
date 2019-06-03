class Exam < ApplicationRecord
  belongs_to :teacher
  mount_uploader :image, ImageUploader
end
