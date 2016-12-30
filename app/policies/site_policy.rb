class SitePolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end
  
    def resolve
      if user.try(:is_admin)
        scope.all
      else
        scope.distinct.joins("cross join (select polygon from moderators_zones mz join zones z on z.id = mz.zone_id where mz.moderator_id = #{user.id}) as t").where("ST_Within(sites.lonlat::geometry, t.polygon) = true")
      end
    end
  end

  def index?
    user.try(:is_admin) || user.try(:is_moderator)
  end

  def update?
    user.try(:is_admin) || user.try(:is_moderator)
  end

  def show?
    true
  end

  def create?
    true
  end

  def rate?
    user.present?
  end

  def comment?
    user.present?
  end
end
