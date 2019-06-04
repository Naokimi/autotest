class ExamsController < ApplicationController
  def index
    @exams = policy_scope(Exam)
  end
end
