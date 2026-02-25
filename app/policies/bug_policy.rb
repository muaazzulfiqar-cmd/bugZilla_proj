class BugPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    return true if user.admin?
    user.present? && membership.present?
  end

  def new?
    create?
  end

  def create?
    return true if user.admin?
    user.present? && membership.present? && (membership.qa? || membership.manager?)
  end

  def edit?
    update?
  end

  def update?
    return true if user.admin?
    user.present? && membership.present? && (
      record.reporter_id == user.id ||
      membership.manager? ||
      (membership.qa? && record.assignee_id == user.id)
    )
  end

  def destroy?
    return true if user.admin?
    user.present? && membership.present? && membership.manager?
  end

  def assign?
    return true if user.admin?
    user.present? && membership.present? && (membership.manager? || membership.developer?)
  end

  def resolve?
    return true if user.admin?
    user.present? && membership.present? && (
      membership.manager? ||
      (membership.developer? && record.assignee_id == user.id) ||
      (membership.qa? && record.assignee_id == user.id)
    )
  end

  private

  def membership
    @membership ||= record.project.project_memberships.find_by(user_id: user.id)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        project_ids = user.project_memberships.pluck(:project_id)
        scope.where(project_id: project_ids)
      end
    end
  end
end
