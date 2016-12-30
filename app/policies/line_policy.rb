class LinePolicy < ApplicationPolicy
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
        scope.distinct.joins("join zones z on ST_Intersects(z.polygon, lines.path)").joins("join moderators_zones mz on mz.zone_id = z.id").where(['mz.moderator_id = ?', user.id])
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
    (user.try(:is_admin) || user.try(:is_moderator)) && scope.where(:id => record.id).exists?
  end
end
