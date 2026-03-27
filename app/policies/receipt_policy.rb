class ReceiptPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def show?
    owner_or_admin?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    owner_or_admin?
  end

  def edit?
    update?
  end

  def destroy?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    user.super_admin? || record.user_id == user.id
  end
end
