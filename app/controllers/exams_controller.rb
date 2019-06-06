class ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :destroy]

  def index
    @exams = policy_scope(Exam)
  end

  def show
    authorize @exam
    @submission = Submission.new
  end

  def create
    @exam = Exam.new(exam_params)
    @exam.teacher_id = current_teacher.id
    authorize @exam

    convert_to_jpg

    if @exam.save
      redirect_to exams_path
    else
      flash[:notice] = 'Failed to save an exam'
      redirect_to root_path
    end
  end

  def convert_to_jpg
    file = params[:exam][:image].tempfile

    if FastImage.type(file) == :tif
      ConvertApi.configure do |config|
        config.api_secret = ENV['CONVERT_API_SECRET']
      end

      result = ConvertApi.convert('jpg', File: file, ImageHeight: '1424', ImageWidth: '1100')
      @exam.remote_image_url = result.files.first.url
    end
  end

  def destroy
    authorize @exam
    @exam.destroy
    redirect_to exams_path
  end

  private

  def set_exam
    @exam = Exam.find(params[:id])
  end

  def exam_params
    params.require(:exam).permit(:image)
    # add inside the params :media => []
    # it will break your logic
  end
end
