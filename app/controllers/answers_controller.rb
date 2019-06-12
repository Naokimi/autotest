class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update]

  def index
    @exam = Exam.find(params[:exam_id])
    @answers = policy_scope(Answer.where("question_id BETWEEN ? AND ?", @exam.questions.first.id, @exam.questions.last.id)).order('question_id , content')
    @incorrect_answers = policy_scope(Answer.where("question_id BETWEEN ? AND ?", @exam.questions.first.id, @exam.questions.last.id)).where("is_correct = false").order('question_id , content')
  end

  def create
    @submission = Submission.find(params[:submission_id])
    @img_path = "https://res.cloudinary.com/naokimi/#{@submission.image.model[:image]}"
    @azure_results = analyze_image(@img_path)
    @questions = Question.where('exam_id = ?', @submission.exam_id)
    @questions.each do |question|
      answer = Answer.create(submission_id: @submission.id, question_id: question.id)
      @azure_results.each do |azure_result|
        x = question.origin_x
        y = question.origin_y
        wi = question.width
        he = question.height
        a = azure_result[0][0]
        b = azure_result[0][1]
        c = azure_result[0][2]
        d = azure_result[0][3]
        e = azure_result[0][4]
        f = azure_result[0][5]
        g = azure_result[0][6]
        h = azure_result[0][7]
        if a >= x && b >= y && c <= (x + wi) && d >= y && e <= (x + wi) && f <= (y + he) && g >= x && h <= (y + he)
          answer.content = azure_result[1].downcase
          if azure_result[1].downcase == question.correct_answer.downcase # setting checking condition to downcase for simpler presentation, can be done dynamically on later versions
            answer.is_correct = true
          else
            answer.is_correct = false
          end
          answer.save
        end
      end
    end
    @answers = Answer.where(submission_id: @submission.id)
    authorize Answer.new

  rescue => e
    p e
  ensure
    respond_to do |format|
      format.html { redirect_to submission_path(@submission) }
      format.js { head :no_content }
    end
  end

  def show
    authorize @answer
  end

  def update
    authorize @answer
    @answer.update(answer_params)

    @answer.save
    redirect_to submission_path(@answer.submission)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content, :is_correct)
  end

  def analyze_image(img_path)
    # Batch Read File API
    uri = URI('https://japaneast.api.cognitive.microsoft.com/vision/v2.0/read/core/asyncBatchAnalyze')
    uri.query = URI.encode_www_form({})
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = ENV['AZURE_API_KEY']
    request.body = "{\'url\': \'#{img_path}\'}"
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    require "pp"
    pp response
    response_url = response.header['operation-location']

    #Wait for 3 seconds
    sleep(10)

    # Get Read Operation Result API
    uri = URI(response_url)
    uri.query = URI.encode_www_form({})
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = ENV['AZURE_API_KEY']
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    json = JSON.parse(response.body)
    pp json
    # puts "Status: #{json['status']}"
    # puts "Width: #{json['recognitionResults'][0]['width']}"
    # puts "Height: #{json['recognitionResults'][0]['height']}"
    results = []
    json['recognitionResults'][0]['lines'].each do |value|
      results << [value['boundingBox'], value['text']]
    end
    return results
  end
end
