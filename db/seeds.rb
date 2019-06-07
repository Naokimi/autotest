# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Emptying database"

Answer.destroy_all
Submission.destroy_all
Question.destroy_all
Exam.destroy_all
Teacher.destroy_all

puts "Creating teacher"

teacher = Teacher.create!(email: "paulo@teacher.com", password: "secret")

puts "Creating exams"

exam = Exam.new(verified: true)
exam.teacher = teacher
exam.remote_image_url = "https://res.cloudinary.com/naokimi/image/upload/v1559622430/autotest/201906041127-3.jpg"
exam.save!

auxiliary_image = "https://i0.wp.com/muthurwa.com/wp-content/uploads/2019/02/Grade-2-English-Exam-Past-Paper-End-Of-Term-1-2018.jpg?fit=822\%2C497&ssl=1"
auxiliary_exam = Exam.new(verified: true)
auxiliary_exam.teacher = teacher
auxiliary_exam.remote_image_url = auxiliary_image
auxiliary_exam.save!

puts "Creating questions"

auxiliary_question = Question.new(correct_answer: "has")
auxiliary_question.exam = auxiliary_exam
auxiliary_question.save!

auxiliary_question = Question.new(correct_answer: "have")
auxiliary_question.exam = auxiliary_exam
auxiliary_question.save!

auxiliary_question = Question.new(correct_answer: "have")
auxiliary_question.exam = auxiliary_exam
auxiliary_question.save!

auxiliary_question = Question.new(correct_answer: "has")
auxiliary_question.exam = auxiliary_exam
auxiliary_question.save!

auxiliary_question = Question.new(correct_answer: "has")
auxiliary_question.exam = auxiliary_exam
auxiliary_question.save!

puts "Creating submissions"

counter = 1
15.times do
  submission = Submission.new(student_number: counter)
  submission.exam = exam
  submission.remote_image_url = "https://res.cloudinary.com/naokimi/image/upload/v155962243#{counter < 10 ? 0 : 1}/autotest/201906041127-#{counter}.jpg"
  submission.save!
  counter += 1
end

counter = 1
30.times do
  auxiliary_submission = Submission.new(student_number: counter)
  auxiliary_submission.exam = auxiliary_exam
  auxiliary_submission.remote_image_url = auxiliary_image
  auxiliary_submission.save!
  counter += 1
end

puts "Creating answers"

Submission.where(exam_id: auxiliary_exam.id).each do |submission|
  question_id = Question.first.id
  5.times do
    typo = ["Has", "Have", "haz", "HAS", "HAVE", "haf", "hass", "hav"].sample
    content = ["has", "have", typo].sample
    answer = Answer.new(question_id: question_id, submission_id: submission.id, content: content)
    answer.is_correct = answer.content == answer.question.correct_answer
    answer.save!
    question_id += 1
  end
end

puts "Finished"
