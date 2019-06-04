class ExamsController < ApplicationController
  def index
    @exams = policy_scope(Exam)
  end

  def show
    @exam = Exam.find(params[:id])
    authorize @exam
  end
end
