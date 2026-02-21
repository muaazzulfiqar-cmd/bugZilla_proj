# app/controllers/bugs_controller.rb
class BugsController < ApplicationController
  before_action :set_project
  before_action :set_bug, only: [:show, :edit, :update, :destroy]

  def new
    @bug = @project.bugs.new
    authorize @bug
  end

  def create
    @bug = @project.bugs.new(bug_params)
    @bug.reporter = current_user
    authorize @bug

    if @bug.save
      redirect_to [@project, @bug], notice: 'Bug was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize @bug
  end

  def edit
    authorize @bug
  end

  def update
    authorize @bug
    
    if @bug.update(bug_params)
      redirect_to [@project, @bug], notice: 'Bug was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @bug
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
end