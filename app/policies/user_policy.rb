class UserPolicy < ApplicationPolicy
  def users_profile?
    owner_or_admin?
  end

  def users_account_settings?
    owner_or_admin?
  end

  def update_profile?
    owner_or_admin?
  end

  def update?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    record == user || user.super_admin?
  end
end