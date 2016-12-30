class UserPolicy < ApplicationPolicy

  def show?
    return true
  end

  def update?
    return true if user.try(:is_admin)
    user == record
  end

end
