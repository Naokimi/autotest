class SubmissionsController < ApplicationController
  def index
    @exam = Exam.find(params[:exam_id])
    @submissions = policy_scope(Submission).where("exam_id = ?", @exam.id)
  end

  def new
    @exam = Exam.find(params[:exam_id])
    @submissions = policy_scope(Submission).where("exam_id = ?", @exam.id)
    authorize @submissions
  end
  
  def pdf
    @submissions = policy_scope(Submission).where("exam_id = ?", params[:id])
    color = "red"
    authorize @submissions
    convert = MiniMagick::Tool::Convert.new
    @submissions.each do |submission|
      img = MiniMagick::Image.open(submission.image.url)
      img.combine_options do |i|
        submission.answers.each do |answer|
          question = answer.question
          i.fill color
          i.gravity 'NorthWest'
          if answer.is_correct
            i.draw "text #{question.origin_x},#{question.origin_y}  'O'"
          else
            i.draw "text #{question.origin_x},#{question.origin_y}  'X'"
          end
          i.pointsize '100'
        end
      end

      path = Rails.root.join("public", "uploads", "#{submission.id}.jpg")
      img.write(path)
      convert << path

    end

    convert << "./public/uploads/#{params[:id]}.pdf"
    convert.call
    pdf_filename = File.join("./public/uploads/#{params[:id]}.pdf")
    send_file(pdf_filename, :filename => "pdf_exams.pdf", :type => "application/pdf")
  end

  def show
    @submission = policy_scope(Submission).find(params[:id])
    @img_path = "https://res.cloudinary.com/naokimi/#{@submission.image.model[:image]}"
    @answers = Answer.where(submission_id: @submission.id).order(:question_id)
    @score = @answers.where('is_correct = true').count
    authorize Submission
  end

  def create
    @exam = Exam.find(params[:exam_id])
    @submission = @exam.submissions.new(submission_params)
    authorize @submission

    if convert_to_jpg_and_save
      respond_to do |format|
        format.html { redirect_to new_exam_submission_path(@exam) }
        format.js { render js: "window.location = '#{new_exam_submission_path(@exam)}';" }
      end
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

      # if needs to fix image size write , ScaleImage: 'true', ImageHeight: '1123', ImageWidth: '795'
      result = ConvertApi.convert('jpg', File: file, ScaleProportions: 'true', TextAntialiasing: '4', GraphicsAntialiasing: '4', ImageInterpolation: 'true', ScaleImage: 'true', ImageHeight: '1695', ImageWidth: '1200')
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
