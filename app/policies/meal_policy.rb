class MealPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def edit?
    record.restaurant.user == user || user.admin
  end

  def update?
    record.restaurant.user == user || user.admin
  end

  def destroy?
    record.restaurant.user == user || user.admin
  end
end
