class MealPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def edit?
    update?
  end

  def update?
    record.restaurant.user == user || record.restaurant.messenger_user == user || user.admin?
  end

  def destroy?
    update?
  end
end
