class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
    @answers = @questions.answers
  end

  def new
    require 'net/http'
    require 'json'

    # Batch Read File API
    uri = URI('https://japaneast.api.cognitive.microsoft.com/vision/v2.0/read/core/asyncBatchAnalyze')
    uri.query = URI.encode_www_form({
    })

    # Create a header and body for new HTTP request
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = '933cd1f2524740a0bb33dd537ed98cd8'
    # Request body
    request.body = "{\"url\": \"https://res.cloudinary.com/dkbhdqszt/image/upload/v1559607758/correct-sheet_dfq73u.jpg\"}"

    #Send the http request to Azure and store the response
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end

    #Store the operation-location
    response_url = response.header['operation-location']

    #Wait for 10 seconds
    sleep(2)

    # Get Read Operation Result API
    uri = URI(response_url)
    uri.query = URI.encode_www_form({
    })

    request = Net::HTTP::Get.new(uri.request_uri)
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = '933cd1f2524740a0bb33dd537ed98cd8'
    # Request body
    # request.body = "{body}"

    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
    end

    @ocr = JSON.parse(response.body, object_class: OpenStruct)
  end
end
