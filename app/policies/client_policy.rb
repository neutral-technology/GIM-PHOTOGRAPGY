# app/policies/client_policy.rb
class ClientPolicy < ApplicationPolicy
  # Scope for index
  class Scope < Scope
    def resolve
      return scope.all if user.super_admin?

      scope.where(user_id: user.id)
    end
  end

  # Permissions

  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def show?
    owner_or_admin?
  end

  def update?
    owner_or_admin?
  end

  def destroy?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    record.user_id == user.id || user.super_admin?
  end
end