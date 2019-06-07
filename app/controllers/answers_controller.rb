class AnswersController < ApplicationController
  def index
    @exam = Exam.find(params[:exam_id])
    @answers = policy_scope(Answer) #.where("exam = ?", @exam)
  end

  def new
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
          if azure_result[1] == question.correct_answer
            answer.content = azure_result[1]
            answer.is_correct = true
            answer.save
          else
            answer.content = azure_result[1]
            answer.is_correct = false
            answer.save
          end
        end
      end
    end
    @answers = Answer.where(submission_id: @submission.id)
    authorize Answer.new
    redirect_to submission_path(@submission)
  end

  def create
  end

  def update
    @answer = Answer.find(params[:id])
    authorize @answer
    @answer.update(answer_params)

    @answer.save
    redirect_to submission_path(@answer.submission)
  end

  private

  def answer_params
    params.require(:answer).permit(:content, :is_correct)
  end

  def analyze_image(img_path)
    # Batch Read File API
    uri = URI('https://japaneast.api.cognitive.microsoft.com/vision/v2.0/read/core/asyncBatchAnalyze')
    uri.query = URI.encode_www_form({})
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = '933cd1f2524740a0bb33dd537ed98cd8'
    request.body = "{\'url\': \'#{img_path}\'}"
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    response_url = response.header['operation-location']

    #Wait for 3 seconds
    sleep(3)

    # Get Read Operation Result API
    uri = URI(response_url)
    uri.query = URI.encode_www_form({})
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Ocp-Apim-Subscription-Key'] = '933cd1f2524740a0bb33dd537ed98cd8'
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    json = JSON.parse(response.body)
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
