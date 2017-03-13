class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    record.user == user || user.admin
  end

  def update?
    record.restaurant.user == user || user.admin
  end
end
