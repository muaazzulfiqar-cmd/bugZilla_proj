# app/policies/project_policy.rb
class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    update?
  end

  def update?
    user.present? && (record.creator_id == user.id || user.project_memberships.find_by(project: record)&.manager?)
  end

  def destroy?
    user.present? && record.creator_id == user.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end