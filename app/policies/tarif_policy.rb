class TarifPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.nil?
        # Public users → only active tarifs
        scope.where(active: true)
      elsif user.super_admin?
        # Admin → everything
        scope.all
      else
        # Photographer → only his tarifs
        scope.where(user: user)
      end
    end
  end

  def show?
    true # public access
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
    user.present? && (record.user_id == user.id || user.super_admin?)
  end
end