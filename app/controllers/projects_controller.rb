class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ edit update destroy report ]

  def index
    @projects = Current.account.projects.order(:name)
  end

  def new
    @project = Current.account.projects.new
  end

  def create
    @project = Current.account.projects.new(project_params)

    if @project.save
      redirect_to projects_path, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project was successfully destroyed."
  end

  def report
    @entries_by_user = @project.time_entries.includes(:user, :card).group_by(&:user)
    @total_duration = @project.time_entries.sum(:duration)
  end

  private
    def set_project
      @project = Current.account.projects.find(params[:id])
    end

    def project_params
      params.expect(project: [ :name, :description ])
    end
end
