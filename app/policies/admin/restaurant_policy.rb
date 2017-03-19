class Admin::RestaurantPolicy < ApplicationPolicy
  def edit?
    update?
  end

  def update?
    user.admin?
  end

  def deliveroo_update?
    update?
  end
end
