module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def show?
      case record.name
      when "Dashboard"
        true
      else
        user.try(:is_admin)
      end
    end
  end
end
