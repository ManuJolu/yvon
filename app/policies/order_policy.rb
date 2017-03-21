class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    record.restaurant.user == user || record.restaurant.messenger_user == user || user.admin?
  end
end
