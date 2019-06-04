class PagesController < ApplicationController
  skip_before_action :authenticate_teacher!, only: [:home]

  def home
    @exam = Exam.new
  end
end
