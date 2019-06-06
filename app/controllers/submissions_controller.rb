class SubmissionsController < ApplicationController
  def index
    @exam = Exam.find(params[:exam_id])
    @submissions = policy_scope(Submission).where("exam_id = ?", @exam.id)
  end

  def create
    @exam = Exam.find(params[:exam_id])
    @submission = @exam.submissions.new(submission_params)
    authorize @submission

    if convert_to_jpg_and_save
      flash[:notice] = 'Successfully uploaded submissions'
      redirect_to exam_submissions_path(@exam)
    else
      flash[:notice] = 'Failed to upload submissions'
      redirect_to exam_path(@exam)
    end
  end

  private

  def convert_to_jpg_and_save
    file = params[:submission][:image].tempfile

    if FastImage.type(file) == :tiff
      ConvertApi.configure do |config|
        config.api_secret = ENV['CONVERT_API_SECRET']
      end

      result = ConvertApi.convert('jpg', File: file, ImageHeight: '1424', ImageWidth: '1100')
      # @submission.remote_image_url = result.files.first.url
      result.files.each do |converted_file|
        @submission = @exam.submissions.new(submission_params)
        @submission.remote_image_url = converted_file.url
        return false unless @submission.save
      end

      return true
    end

    @submission.save
  end

  def submission_params
    params.require(:submission).permit(:image, :exam_id)
  end
end
