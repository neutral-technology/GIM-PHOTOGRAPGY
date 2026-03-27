class AlbumPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.nil?
        # Public users → only public albums
        scope.where(public: true)
      elsif user.super_admin?
        # Admin → everything
        scope.all
      else
        # Photographer → his albums + public ones
        scope.where(user: user).or(scope.where(public: true))
      end
    end
  end

  # 👁️ VIEW
  def show?
    return true if record.public?
    return false unless user

    owner_or_admin?
  end

  # ➕ CREATE
  def create?
    user.present?
  end

  def new?
    create?
  end

  # ✏️ UPDATE
  def update?
    owner_or_admin?
  end

  def edit?
    update?
  end

  # ❌ DELETE
  def destroy?
    owner_or_admin?
  end

  # 🔐 Generate password
  def generate_password?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    user.present? && (record.user_id == user.id || user.super_admin?)
  end
end
