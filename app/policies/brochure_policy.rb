# app/policies/brochure_policy.rb
class BrochurePolicy < ApplicationPolicy
  # Le "Scope" définit ce que l'utilisateur peut voir dans une liste (index)
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all # Je vois tout le monde
      else
        scope.where(user: user) # Le photographe ne voit que SES brochures
      end
    end
  end

  # Autoriser la vue détaillée
  def show?
    is_admin_or_owner?
  end

  # Autoriser la création
  def create?
    user.super_admin? || user.photographer?
  end

  # Autoriser l'édition et la mise à jour
  def update?
    is_admin_or_owner?
  end

  # Custom actions
  def edit_layout?
    update?
  end

  def update_theme?
    update?
  end

  # Autoriser la suppression
  def destroy?
    is_admin_or_owner?
  end
end
