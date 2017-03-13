class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    record == user || user.admin?
  end

  def update?
    show?
  end
end
