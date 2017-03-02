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
    update?
  end

  def update?
    record.user == user || user.admin
  end

  def refresh?
    update?
  end

  def duty_update?
    update?
  end

  def preparation_time_update?
    update?
  end
end
