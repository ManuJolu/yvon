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
    user.restaurant_owner? || user.admin?
  end

  def edit?
    update?
  end

  def update?
    record.user == user || record.messenger_user == user || user.admin?
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

  def facebook_update?
    update?
  end
end
