# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  def users_profile?
    # Allow if it's their own profile OR if they are an admin
    # is_admin_or_owner?
    record == user || user.super_admin?
  end

  def users_account_settings?
    users_profile?
  end

  def update_profile?
    users_profile?
  end

  # Add this if you have a general update action
  def update?
    users_profile?
  end
end
