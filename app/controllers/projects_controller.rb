class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @my_projects = current_user.projects.includes(:project_memberships)
    @all_projects = Project.all.includes(:creator).page(params[:page]).per(20)
    authorize Project
  end

  def show
    authorize @project
    @bugs = @project.bugs
  end

  def new
    @project = Project.new
    authorize @project
  end

  def create
    @project = current_user.created_projects.build(project_params)
    authorize @project

    if @project.save
      @project.project_memberships.create!(
        user: current_user,
        role: :manager
      )
      
      redirect_to @project, notice: "Project created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project
    if @project.update(project_params)
      redirect_to @project, notice: "Project updated."
    else
      render :edit
    end
  end

  def destroy
    authorize @project
    @project.destroy
    redirect_to projects_path, notice: "Project deleted."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end