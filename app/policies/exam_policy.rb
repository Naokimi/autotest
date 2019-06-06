class ExamPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def show?
    return true
  end

  def edit?
    return true
  end

  def update?
    return true
  end

  def destroy?
    true
  end
end
