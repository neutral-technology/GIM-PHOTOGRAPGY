class ExpensePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def refund?
    owner_or_admin?
  end

  def cancel?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    user.super_admin? || record.user_id == user.id
  end
end