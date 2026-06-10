# app/policies/brochure_block_policy.rb
class BrochureBlockPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.joins(brochure_page: :brochure)
            .where(brochures: { user_id: user.id })
      end
    end
  end

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
