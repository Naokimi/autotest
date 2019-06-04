class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
    @answers = @questions.answers
  end
end
