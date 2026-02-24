# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = current_user.projects.includes(:project_memberships)
    @memberships = current_user.project_memberships.includes(:project)
    @assigned_bugs = current_user.assigned_bugs.open.includes(:project)
    
    @open_count = Bug.open.count
    @resolved_count = Bug.resolved.count
    
    @global_role = current_user.global_role
  end
end