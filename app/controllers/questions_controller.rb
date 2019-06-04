class QuestionsController < ApplicationController
  def index
    @exam = Exam.find(params[:exam_id])
    @questions = policy_scope(Question)
  end


  def show
    @question = Question.find(params[:id])
    @answers = @questions.answers
  end
end
