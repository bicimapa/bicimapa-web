class RidePolicy < ApplicationPolicy
	
  def index?
    true
  end

  def update?
    return true if user.try(:is_admin)
    return true if record.user == user
  end

  def create?
    true
  end

  def show?
    true
  end

end
