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

  def foodora_update?
    update?
  end

  def ubereats_update?
    update?
  end

  def messenger_codes?
    update?
  end
end
