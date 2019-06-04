class SubmissionsController < ApplicationController
  def create
    @exam = Exam.find(params[:exam_id])
    @submission = Submission.new(submission_params)
    @submission.exam_id = @exam.id
    authorize @submission
    if @submission.save
      flash[:notice] = 'Successfully uploaded submissions'
      redirect_to exam_path(@exam)
    else
      flash[:notice] = 'Failed to upload submissions'
      redirect_to exam_path(@exam)
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:image, :exam_id)
  end
end
