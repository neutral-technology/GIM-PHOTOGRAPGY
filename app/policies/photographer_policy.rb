class PhotographerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    user.present?
  end
end
