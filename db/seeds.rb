# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Emptying database"

Submission.destroy_all
Exam.destroy_all
Teacher.destroy_all

puts "Creating teacher"

teacher = Teacher.create!(email: "paulo@teacher.com", password: "secret")

puts "Creating exam"

exam = Exam.new
exam.teacher = teacher
exam.remote_image_url = "https://res.cloudinary.com/naokimi/image/upload/v1559622430/autotest/201906041127-3.jpg"
exam.save!

puts "Creating submissions"

counter = 1
15.times do
  submission = Submission.new(student_number: counter)
  submission.exam = exam
  submission.remote_image_url = "https://res.cloudinary.com/naokimi/image/upload/v155962243#{counter < 10 ? 0 : 1}/autotest/201906041127-#{counter}.jpg"
  submission.save!
  counter += 1
end

puts "Finished"
