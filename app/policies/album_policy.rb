class AlbumPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        scope.where(user: user).or(scope.where(public: true))
      else
        scope.where(public: true)
      end
    end
  end
end
