class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = current_user.projects.includes(:project_memberships)
    
    # Get bugs assigned to current user
    @assigned_bugs = current_user.assigned_bugs.open.includes(:project)
    
    # Get project memberships with role information
    @memberships = current_user.project_memberships.includes(:project)
    
    # Get role for current project (if you want to show current project context)
    @current_role = @memberships.find_by(project: @projects.first)&.role if @projects.any?
    
    # Bug counts
    @open_count = Bug.open.count
    @resolved_count = Bug.resolved.count
    
    # Optional: Group projects by role
    @projects_by_role = @memberships.group_by(&:role)
  end
end