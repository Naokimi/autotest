class SubmissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def show?
    true
  end

  def pdf?
    true
  end

  def new?
    true
  end
end
