# app/controllers/bugs_controller.rb
class BugsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  
  rescue_from Pundit::NotAuthorizedError, with: :bug_not_authorized

  def index
    @bugs = @project.bugs.includes(:reporter, :assignee)
    authorize Bug
  end

  def show
    authorize @bug
  end

  def new
    @bug = @project.bugs.new
    authorize @bug
  end

  def create
    @bug = @project.bugs.new(bug_params)
    @bug.reporter = current_user
    authorize @bug

    if @bug.save
      if @bug.assignee.present?
        BugMailer.bug_assigned(@bug, @bug.assignee).deliver_later
        flash[:notice] = "Bug was successfully created and assigned to #{@bug.assignee.email}."
      else
        flash[:notice] = 'Bug was successfully created.'
      end
      redirect_to [@project, @bug]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @bug
  end

  def update
    authorize @bug
    
    # Track changes for notifications
    old_assignee = @bug.assignee
    old_status = @bug.status
    old_priority = @bug.priority
    
    if @bug.update(bug_params)
      # Send email if assignee changed
      if @bug.assignee.present? && old_assignee != @bug.assignee
        BugMailer.bug_assigned(@bug, @bug.assignee).deliver_later
        flash[:notice] = "Bug updated and reassigned to #{@bug.assignee.email}."
      
      # Send email if unassigned
      elsif old_assignee.present? && @bug.assignee.nil?
        BugMailer.bug_unassigned(@bug, old_assignee).deliver_later
        flash[:notice] = "Bug updated and unassigned from #{old_assignee.email}."
      
      # Send email if status changed
      elsif old_status != @bug.status
        BugMailer.bug_status_changed(@bug, old_status, @bug.status).deliver_later
        flash[:notice] = "Bug status updated from #{old_status.humanize} to #{@bug.status.humanize}."
      
      else
        flash[:notice] = 'Bug was successfully updated.'
      end
      
      redirect_to [@project, @bug]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @bug
    
    # Notify assignee that bug was deleted
    if @bug.assignee.present?
      BugMailer.bug_deleted(@bug, @bug.assignee).deliver_later
    end
    
    @bug.destroy
    redirect_to @project, notice: 'Bug was successfully deleted.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bug
    @bug = @project.bugs.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :status, :priority, :assignee_id, screenshots: [])
  end

  def bug_not_authorized(exception)
    case exception.query
    when :new?, :create?
      flash[:alert] = "You don't have permission to create bugs in this project. Only QA and Managers can create bugs."
      redirect_to @project
    when :edit?, :update?
      flash[:alert] = "You can only edit bugs that are assigned to you or that you reported."
      redirect_to [@project, @bug]
    when :destroy?
      flash[:alert] = "Only managers can delete bugs."
      redirect_to [@project, @bug]
    else
      flash[:alert] = "You are not authorized to perform this action."
      redirect_back(fallback_location: @project)
    end
  end
end