# app/policies/brochure_block_policy.rb
class BrochureBlockPolicy < ApplicationPolicy
  def update?
    # Ensure the user is admin or the owner of the brochure this block belongs to
    user.super_admin? || record.brochure_page.brochure.user == user
  end

  # Alias the other actions to the same permission
  def update_image?
    update?
  end

  def reorder?
    update?
  end
end
