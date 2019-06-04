class ExamsController < ApplicationController
  def index
    @exams = policy_scope(Exam)
  end

  def show
    @exam = Exam.find(params[:id])
    authorize @exam
    @submission = Submission.new
  end

  def create
    @exam = Exam.new(exam_params)
    @exam.teacher_id = current_teacher.id
    authorize @exam
    if @exam.save
      redirect_to exams_path
    else
      flash[:notice] = 'Failed to save an exam'
      redirect_to root_path
    end
  end

  private

  def exam_params
    params.require(:exam).permit(:image)
  end
end
