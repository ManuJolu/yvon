class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    record == user || user.admin?
  end

  def credit_card_update?
    show?
  end

  def credit_card_destroy?
    credit_card_update?
  end
end
