class ExamsController < ApplicationController
  skip_before_action :authenticate_teacher!, only: [:show]

  def index
    @exams = policy_scope(Exam)
  end

  def show
    @exam = Exam.find(params[:id])
    authorize @exam
  end
end
