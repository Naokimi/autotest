class QuestionsController < ApplicationController
  before_action :set_exam, only: [:index, :new, :create]

  def index
    @questions = policy_scope(Question)
  end

  def show
    @question = policy_scope(Question).find(params[:id])
    authorize @question
    @answers = @question.answers.order('content')
    @incorrect_answers = @question.answers.where("is_correct = false").order('content')
  end

  def new
    uri = URI('https://japaneast.api.cognitive.microsoft.com/vision/v2.0/read/core/asyncBatchAnalyze')
    uri.query = URI.encode_www_form({})
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = ENV['AZURE_API_KEY']
    # Request body

    request.body = "{\"url\": \"#{@exam.image.url}\"}"

    # Send the http request to Azure and store the response
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    # Store the operation-location
    response_url = response.header['operation-location']

    # Wait for 10 seconds (coming from Azure's documentation)
    sleep(3)

    # Get Read Operation Result API
    uri = URI(response_url)
    uri.query = URI.encode_www_form({})
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = ENV['AZURE_API_KEY']
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    @ocr = JSON.parse(response.body, object_class: OpenStruct)
    @question = Question.new
    @exam = Exam.find(params[:exam_id])
    authorize @question
  end

  def create
    @question = Question.new(question_params)
    authorize @question

    @question.exam = @exam

    @qid = params[:question][:qid]

    if @question.save
      respond_to do |format|
        format.html { redirect_to redirect_to exam_path(@exam) }
        format.js # <-- will render `app/views/reviews/create.js.erb`
      end

    else
      render 'exams/show'
    end
  end

  private

  def set_exam
    @exam = Exam.find(params[:exam_id])
  end

  def question_params
    params.require(:question).permit(:correct_answer, :origin_x, :origin_y, :width, :height)
  end
end
