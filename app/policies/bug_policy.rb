# app/policies/bug_policy.rb
class BugPolicy < ApplicationPolicy
  def index?
    # Anyone can see bugs if they have access to the project
    user.present?
  end

  def show?
    # Users can see bugs in projects they're members of
    user.present? && membership.present?
  end

  def new?
    create?
  end

  def create?
    # QA and managers can create bugs
    user.present? && membership.present? && (membership.qa? || membership.manager?)
  end

  def edit?
    update?
  end

  def update?
    # Reporters can edit their own bugs, and managers can edit any bug in their project
    user.present? && membership.present? && (
      record.reporter_id == user.id ||
      membership.manager? ||
      (membership.qa? && record.assignee_id == user.id)
    )
  end

  def destroy?
    # Only managers can delete bugs
    user.present? && membership.present? && membership.manager?
  end

  def assign?
    # Managers and developers can assign bugs
    user.present? && membership.present? && (membership.manager? || membership.developer?)
  end

  def resolve?
    # Developers and QA can resolve bugs assigned to them, managers can resolve any
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
      if user.present?
        # Get all projects the user is a member of, then get all bugs from those projects
        project_ids = user.project_memberships.pluck(:project_id)
        scope.where(project_id: project_ids)
      else
        scope.none
      end
    end
  end
end