class ProjectMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :authorize_management!

  def index
    @memberships = @project.project_memberships.includes(:user)
    @available_users = User.where.not(id: @project.users.pluck(:id))
  end

  def create
    @membership = @project.project_memberships.new(membership_params)
    
    if @membership.save
      redirect_to project_project_memberships_path(@project), notice: "#{@membership.user.email} was added as #{@membership.role.humanize}."
    else
      redirect_to project_project_memberships_path(@project), alert: "Failed to add member: #{@membership.errors.full_messages.join(', ')}"
    end
  end

  def update
    @membership = @project.project_memberships.find(params[:id])
    old_role = @membership.role.humanize
    
    if @membership.update(membership_params)
      redirect_to project_project_memberships_path(@project), notice: "#{@membership.user.email}'s role changed from #{old_role} to #{@membership.role.humanize}."
    else
      redirect_to project_project_memberships_path(@project), alert: "Failed to update role."
    end
  end

  def destroy
    @membership = @project.project_memberships.find(params[:id])
    
    if @membership.user == current_user
      redirect_to project_project_memberships_path(@project), alert: "You cannot remove yourself from the project."
    elsif @membership.user == @project.creator && !current_user.admin?
      redirect_to project_project_memberships_path(@project), alert: "Cannot remove the project creator."
    else
      user_email = @membership.user.email
      @membership.destroy
      redirect_to project_project_memberships_path(@project), notice: "#{user_email} was removed from the project."
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def authorize_management!
    return if current_user.admin?
    membership = @project.project_memberships.find_by(user: current_user)
    unless membership&.manager?
      redirect_to @project, alert: "Only managers and admins can manage team members."
    end
  end

  def membership_params
    params.require(:project_membership).permit(:user_id, :role)
  end
end