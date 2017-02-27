class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    true
  end

  def create?
    true
  end

  def edit?
    record.user == user || user.admin
  end

  def update?
    record.user == user || user.admin
  end

  def duty?
    record.user == user || user.admin
  end
end
